Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab1FFWc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:32:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:43045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab1FFWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:32:26 -0400
Subject: Re: Changing Kernel thread priorities
From: Peter Zijlstra <peterz@infradead.org>
To: hannes_bauer@aon.at
Cc: Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx <tglx@linutronix.de>
In-Reply-To: <4829399.10721.1307362225402.JavaMail.root@WARSBL213.highway.telekom.at>
References: <4829399.10721.1307362225402.JavaMail.root@WARSBL213.highway.telekom.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 00:36:01 +0200
Message-ID: <1307399761.2497.989.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-MIME-Error: demime acl condition: uuencoded line length is not a multiple of 4 characters
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Monica Puig-Pey" <puigpeym@unican.es> wrote:
> 
> I need to change the priority from inside the driver, when creating the 
> kernel thread.

No you don't. How does you driver know about what priority is correct
wrt all the other running RT tasks on the system?

Determining the right priority in a fixed priority scheduling system is
a system wide problem, nobody but the administrator can possibly even
begin to solve it.

There's a reason all RT irq threads are started at 50, its plain
impossible to do better.

