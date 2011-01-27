Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1A0Nzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:55:48 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42398 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214Ab1A0Nzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:55:45 -0500
X-Sasl-enc: q8f7E1xvvr2gApq7w8Iqo2aRBvx0NDyAIO2wEQk8lwjq 1296136544
Date: Thu, 27 Jan 2011 11:55:40 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dominik Kopp <my@kabelfunk.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] thinkpad-acpi: fn-f4 issues
Message-ID: <20110127135540.GA18579@khazad-dum.debian.net>
References: <Pine.LNX.4.64.1101251740380.3737@boston.corp.fedex.com>
 <20110125151346.GB14803@khazad-dum.debian.net>
 <4D3F3AFF.7020407@kabelfunk.de>
 <20110125231651.GB25953@khazad-dum.debian.net>
 <4D409953.7020205@kabelfunk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D409953.7020205@kabelfunk.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Dominik Kopp wrote:
> Am 26.01.2011 00:16, schrieb Henrique de Moraes Holschuh:
> >The driver IS asking for Fn+F4 events. Please send me the output of
> >acpidump, gzipped.
> acpidump attached.
> >In the meanwhile, check if the input device is producing events when
> >you're pressing Fn+f4.  It could well be sending KEY_SUSPEND, but if
> >there's nobody listening...
> >
> do you mean xev?
> if yes: they are producing KeyPress and KeyRelease events (but nothing else)

So, not a driver bug.  Take it up with your userspace distro...

>     state 0x0, keycode 150 (keysym 0x1008ff2f, XF86Sleep), same_screen YES,

It is even mapped to the correct X keysim...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
