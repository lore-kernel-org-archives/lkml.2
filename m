Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2GUVOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 17:14:18 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:59002 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2GUVOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 17:14:17 -0400
Date: Sat, 21 Jul 2012 23:01:06 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
Message-ID: <20120721210106.GA6111@electric-eye.fr.zoreil.com>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com> <CA+55aFwZRvtpE2e3zNqvtobpPROqw_bOwNt+=DBzmScV0_rq=w@mail.gmail.com> <CACVXFVPupumYqeBwTwgK3C04VQBxOjkFMbaKQ-Gsz3teCWqQ=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPupumYqeBwTwgK3C04VQBxOjkFMbaKQ-Gsz3teCWqQ=w@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> :
> On Sun, Jul 22, 2012 at 1:31 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Fri, Jul 20, 2012 at 5:33 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> >> The RFC patch is just for discussing if the idea of deferring
> >> request_firmware is doable for addressing the issue of
> >> request_firmware in resume path, which is caused by driver
> >> unbind/rebind during resume.
> >
> > NAK.
> 
> Suppose it is not good for resume case, I think it still makes sense
> for early boot
> situation, at least the patch will support to request firmware inside
> init call, and
> allow drivers to be built in kernel in case of requesting firmware from probe().

Could there be a simple, static and inefficient way to link firmware
and code together ?

-- 
Ueimor
