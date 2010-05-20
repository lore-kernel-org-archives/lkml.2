Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab0ETFFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 01:05:36 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:52373 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab0ETFFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 01:05:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=xeOwzLTOCJEjErGm4Do/WJcgJOS99va5kd433S/AXTIloyjH0BS4FsoJk+1xdK1p4F
         oNBiFSSzff0p94QeCzh/7ambX7KZ+Y+dcZqI9R95l6F6Kwn89qo6aBng5EKw2j6LK73L
         3Rx9PALAyuRTo+XwvHxkEvb8WGYdiBwC0Dy58=
MIME-Version: 1.0
In-Reply-To: <20100519154618.GA26381@atrey.karlin.mff.cuni.cz>
References: <20100519154618.GA26381@atrey.karlin.mff.cuni.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 20 May 2010 13:05:14 +0800
Message-ID: <AANLkTim49akRJK0BN_Qk1wL6e5mrdjZioDjGNWlrjUVQ@mail.gmail.com>
Subject: Re: usb gadget on zaurus and kexec
To: Cyril Hrubis <metan@ucw.cz>
Cc: pave@ucw.cz, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:46 PM, Cyril Hrubis <metan@ucw.cz> wrote:
> Hi!
> After some testing I found out that no usb gadget (g_ether, g_mass_storage, ...)
> is working after zaurus boots with kexec. So it seems like some missing
> initalization (it's working after doing reboot again) anybody has any clue,
> patch or ideas how to debug this?
>

Dumping out the registers of the two situations and doing a comparison then
might be a quick way.
