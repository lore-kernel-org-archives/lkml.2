Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1HRIVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:21:11 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:41703 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237Ab1HRIUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:20:25 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Aug 2011 04:20:24 EDT
From: Marc Dietich <marvin24@gmx.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Staging: nvec: Fixed various style issues.
Date: Thu, 18 Aug 2011 10:05:10 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc2+; KDE/4.6.5; x86_64; ; )
Cc: Akshay Joshi <me@akshayjoshi.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Vitaliy Ivanov <vitalivanov@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1313613397-18126-1-git-send-email-me@akshayjoshi.com> <201108180858.58200.marvin24@gmx.de> <1313652623.32547.56.camel@Joe-Laptop>
In-Reply-To: <1313652623.32547.56.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108181005.10977.marvin24@gmx.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: marvin24@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Joe,

> > On Thu, 2011-08-18 at 08:58 +0200, Marc Dietrich wrote:
> > Greg, I haven't yet heard of Joe (a reviewer, see:
> > http://driverdev.linuxdriverproject.org/pipermail/devel/2011-August/01921
> > 7.html) for some days now.
>
> I thought I was pretty clear in my reviewvand
> didn't need to reply further.
> 
> I think mixing index # and field comment in the
> same style isn't very readable.
> 
> It's your code, do what you think best.

this file certainly needs another cleanup (or maybe be moved into nvec_kbd.c). I 
just want to make "small" steps.

Thanks

Marc
