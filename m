Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0CVIAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:00:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab0CVIAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:00:05 -0400
Date: Mon, 22 Mar 2010 00:58:59 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc Zyngier <maz@misterjones.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jebediah Huang <jebediah.huang@gmail.com>
Subject: Re: [PATCH] gpio: add interrupt handling capability to max732x
Message-Id: <20100322005859.93268cfc.akpm@linux-foundation.org>
In-Reply-To: <20100322073946.5277f6ed@taxman.wild-wind.fr.eu.org>
References: <4ed0c90d27185c38ccb15d6d4442cfd4@localhost>
	<20100319164156.87b6fc43.akpm@linux-foundation.org>
	<20100322073946.5277f6ed@taxman.wild-wind.fr.eu.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010 07:39:46 +0000 Marc Zyngier <maz@misterjones.org> wrote:

> Would the following patch (against the original version) address your
> concerns?

Gee, I dunno.  Is it necessary?  I thought your earlier explanation
covered everything OK.

I wouldn't say I had concerns really - I just poke people to verify
that problems didn't sneak through.  If you think it improves the
driver, sure, add it?

