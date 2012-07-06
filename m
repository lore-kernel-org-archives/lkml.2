Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab2GFRD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:03:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53824 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2GFRD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:03:57 -0400
Date: Fri, 6 Jul 2012 10:03:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yuri Khan <yurivkhan@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/1] Input: xpad - Add a variation of Mad Catz Beat Pad
Message-ID: <20120706170350.GA9909@core.coreip.homeip.net>
References: <1341592324-665-1-git-send-email-yurivkhan@gmail.com>
 <CAP_d_8WLyGPtfWY3Po4yYyg2L7EiWuWuF6X4WZ+Me6LMLwfDCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP_d_8WLyGPtfWY3Po4yYyg2L7EiWuWuF6X4WZ+Me6LMLwfDCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 11:57:44PM +0700, Yuri Khan wrote:
> On Fri, Jul 6, 2012 at 11:32 PM, Yuri Khan <yurivkhan@gmail.com> wrote:
> 
> > When I add a usbhid option quirks=0x0738:0x4540:0x4 (so that usbhid does
> > not attempt to handle this device) and rebuild the xpad module with the
> > following patch, the device works as expected. Dmitry Torokhov, the
> > current maintainer of input drivers, suggested that I include a change
> > to add the usbhid quirk in my patch.
> 
> Of course the good idea only ever comes after the fact. If I change
> usbhid to ignore this vendor:device unconditionally, then xpad should
> also always handle it regardless of interface class/subclass/protocol,
> right?

Yes.

-- 
Dmitry
