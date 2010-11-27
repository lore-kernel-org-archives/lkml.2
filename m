Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab0K0ITL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 03:19:11 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41252 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab0K0ITH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 03:19:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tpXO8aLbu6Sg1g9amCfJNLbn0xVW0/XMSUNwMGHnI4iiyRdeM154WE6tcRvCXTNX4b
         C1PuNmCUuoMq5m0sQrngvxULw8uzjw2qgXod3hKkpURiYpGWWQjMY9QE6oqo5dfa1aHb
         LMLpH/ZMHccHB06LNFBOzrBQAgpYwu2ood1d0=
Date: Sat, 27 Nov 2010 00:19:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Fabien Marteau <fabien.marteau@armadeus.com>
Cc: Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver
Message-ID: <20101127081900.GE28667@core.coreip.homeip.net>
References: <4CEBED7E.7010101@armadeus.com>
 <20101124195523.GF27368@core.coreip.homeip.net>
 <4CEE3632.6020502@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEE3632.6020502@armadeus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 11:10:58AM +0100, Fabien Marteau wrote:
> > 
> > Just why does it have to be separately allocated? I'd even stick with
> > "as5011" for all IRQ names.
> 
> I thought that irq name should be different for each IRQ used under device and
> for each device used in system. I can use the same irq name if I've got several
> as5011 joystick in the same system ?

No, it's just a tag shown in /proc/interrupts and a few other places.
Simply a driver name would work splendidly.

Thanks.

-- 
Dmitry
