Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab2BSXIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 18:08:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35212 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2BSXIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 18:08:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.14.28.194 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
Message-ID: <1329692938.10124.25.camel@lappy>
Subject: Re: TTY: NULL dereference when closing a pty file
From: Sasha Levin <levinsasha928@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Dave Jones <davej@redhat.com>
Date: Mon, 20 Feb 2012 01:08:58 +0200
In-Reply-To: <4F41653A.3090307@gmail.com>
References: <1329683796.10124.21.camel@lappy> <4F41653A.3090307@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-19 at 22:10 +0100, Jiri Slaby wrote:
> On 02/19/2012 09:36 PM, Sasha Levin wrote:
> > I got the following BUG() when running trinity on the KVM tool:
> 
> Hi, I've sent a patch as a reply to your message. Could you test it?

Sure. I'll re-run and report back tomorrow.

> And where can one obtain the tool?

The KVM tool is developed at https://github.com/penberg/linux-kvm

Trinity is developed at http://codemonkey.org.uk/projects/trinity/trinity.git

If you have any questions about how to use them both feel free to message me privately.

> thanks,


