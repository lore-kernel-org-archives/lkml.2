Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0LOOlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:41:08 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50474 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752371Ab0LOOlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:41:06 -0500
Date: Wed, 15 Dec 2010 15:40:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, microcai@fedoraproject.org,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101215144055.GA10467@ucw.cz>
References: <1290941875.13526.15.camel@cai.gentoo>
 <87mxosla7p.fsf@basil.nowhere.org>
 <20101213071328.GB2328@ucw.cz>
 <20101213101801.1f698c7c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213101801.1f698c7c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes. These days kernel sources and kernel messages both contain
> > non-ASCII characters... as well as many filesystems.
> 
> But not in kernel printed messages.

Yes, even in those (but something eats my mail).

CAFE driver has non-ascii characters in pci device name, and that
leaks to dmesg.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
