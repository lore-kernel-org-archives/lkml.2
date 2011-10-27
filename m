Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab1J0PJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:09:45 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:45313 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848Ab1J0PJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:09:44 -0400
X-Sasl-enc: fRpjJsNWqEvNAu7NSPyUamIARAA1JG1nXwTeGYvjNlFK 1319728183
Date: Thu, 27 Oct 2011 17:01:03 +0200
From: Greg KH <greg@kroah.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] TTY: pty, fix pty counting in
 "/proc/sys/kernel/pty/nr"
Message-ID: <20111027150103.GC10883@kroah.com>
References: <4EA928F3.7010204@ilyx.ru>
 <20111027123742.GB7910@kroah.com>
 <4EA95788.90808@ilyx.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA95788.90808@ilyx.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 05:07:20PM +0400, Ilya Zykov wrote:
> Greg KH wrote:
> 
> > On Thu, Oct 27, 2011 at 01:48:35PM +0400, Ilya Zykov wrote:
> >> Regression for commit: 24d406a6bf736f7aebdc8fa0f0ec86e0890c6d24
> >> Commit: 24d406a6b accepted in Linux 3.1.
> >> Disscussed on linux-kernel@vger.kernel.org "subject: [PATCH] TTY: pty, fix pty counting"
> >> and not accepted.
> >> Although, I think it's clear.
> > 
> > Ilya, is there some reason you are ignoring the tty maintainer and
> > sending these to Linus directly?  These patches need to be tested in
> > linux-next, so at the earliest, they can be merged into Linus's tree for
> > 3.3, they are NOT 3.2 material, especially given that they are not even
> > accepted by the current tty developers.
> > 
> > So please work with us, and don't try to circumvent the existing
> > process, it is not the way we work here.
> > 
> > Especially as this specific patch was already rejected, for very good
> > reasons, why are you ignoring those reasons?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> 
> OK, I understand you rules. 
> But I don't understand, what for, you accept patch(commit:
> 24d406a6bf736f7aebdc8fa0f0ec86e0890c6d24), where "pty" call
> tty_driver_remove_tty(), only for invoke its own
> route(pty_unix98_remove).

Please work with Alan and Jiri to get their acceptance of your patch,
they are the ones that need to ack it before I will.

thanks,

greg k-h
