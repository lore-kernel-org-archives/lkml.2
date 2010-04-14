Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab0DNW4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:56:15 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:44400 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab0DNW4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:56:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Unhx8WzUSye/Fs1kwRiYWMH/DEkyHC6m/Mm1eXjF7HvO2mCwb2dqtkTN2SX47ZeH0A
         Gts77AKRjm34NabVJE2ZWMDSP1eq0Evt6n7WQLbRleq0O/pc4dth8EQzhEmYwILy9mdh
         yLsGd5TptGNVSGzdxmF3cDtUfzM1R3c2iRMHg=
Date: Wed, 14 Apr 2010 15:56:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: liux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Linux <linux-kernel@vger.kernel.org>,
       Linux USB <linux-usb@vger.kernel.org>
Subject: Re: Handling macros with input devices
Message-ID: <20100414225608.GB12143@core.coreip.homeip.net>
References: <054d04d6a47f4ba368c8d75f8d8fb08f.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <054d04d6a47f4ba368c8d75f8d8fb08f.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rick,

On Wed, Apr 14, 2010 at 12:19:30PM -0600, Rick L. Vinyard, Jr. wrote:
> One of the sticking points I have with the G13 driver is that I'd like it
> to have support for macros. The reason I'd like to support macros is that
> the G13's raison d'etre is to allow the end user to customize the device
> with their own macros.
> 
> However, I've been looking around and I can't find any support for macros
> within the kernel.
> 
> In particular, I have support for getkeycode and setkeycode ioctl's. I was
> thinking of supporting at least setkeycode to allow a standard way to set
> a one key macro. Supporting getkeycode and setting keybit are more
> problematic.
> 
> If someone has already brought this issue up I apologize, but I couldn't
> find any discussion on the linux-input list relating to macros (at least
> other than preprocessor macros).
> 
> Any suggestions?
> 

I consider macro handling to be userspace task. If needed, macro
sequences can be injected back into the kernel via uinput devices to be
consumed by regualar applications.

-- 
Dmitry
