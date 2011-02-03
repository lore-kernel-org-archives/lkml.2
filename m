Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1BCR5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:57:36 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38148 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab1BCR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:57:35 -0500
Date: Thu, 3 Feb 2011 18:58:45 +0100
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EDAC-AMD64] Display correct RAM sizes in ganged mode on F10
 CPUs
Message-ID: <20110203175845.GC26261@aftab>
References: <20110129211531.GA1874@gentoo.trippels.de>
 <20110201185114.GD8418@aftab>
 <20110201192752.GA1589@gentoo.trippels.de>
 <20110203151721.GD24755@aftab>
 <20110203155951.GA1594@gentoo.trippels.de>
 <20110203163600.GA26261@aftab>
 <20110203164203.GB1594@gentoo.trippels.de>
 <20110203170932.GB26261@aftab>
 <20110203172539.GA1581@gentoo.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110203172539.GA1581@gentoo.trippels.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 12:25:39PM -0500, Markus Trippelsdorf wrote:
> Looks good, many thanks Boris.
> 
> EDAC amd64: F10h detected (node 0).
> EDAC MC: DCT0 chip selects:
> EDAC amd64: MC: 0:  1024MB 1:  1024MB
> EDAC amd64: MC: 2:  1024MB 3:  1024MB
> EDAC amd64: MC: 4:     0MB 5:     0MB
> EDAC amd64: MC: 6:     0MB 7:     0MB
> EDAC MC: DCT1 chip selects:
> EDAC amd64: MC: 0:  1024MB 1:  1024MB
> EDAC amd64: MC: 2:  1024MB 3:  1024MB
> EDAC amd64: MC: 4:     0MB 5:     0MB
> EDAC amd64: MC: 6:     0MB 7:     0MB

Ok thanks, will add your Tested-by: too.

> BTW another thing, while I have your attention:
> 
> cat /sys/devices/system/edac/mc/mc0/csrow0/edac_mode
> prints "S4ECD4ED" aka Chipkill on my system.
> But I'm using a revision C Phenom that only supports a x4 symbol size,
> while the Kingston ECC DIMMs have a width of x8. So according to
> table 77 (page 174) of the "BIOS and Kernel Developer’s Guide" the
> system is actually running in SECDED mode and does not provide Chipkill.

Yeah, that table needs to be implemented for proper csrow->edac_mode
assignment. I'll try to get it done soon.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
