Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0HPQUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:20:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60289 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab0HPQUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:20:16 -0400
Message-ID: <4C69653E.6050808@vlnb.net>
Date: Mon, 16 Aug 2010 20:20:14 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Fwd: Re: [Scst-devel] linuxcon 2010...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:4Wd6H6RsTL8RPe2Rrx0/ugd91jvat1M5kNAmiJ3tq4I
 A3E6pFPdLmG88HH+FpTePj5QvxxrBDvaBLPNvcRLNsu5jPH472
 MeVuTN4iR568ZsVAweNIMYv9Aj6hxp0/xTCxqCqHA+RdHnKfLD
 L162wn44ghsgxAoXAO46sN5aHlL+/KYkrvGnks0vn0QvCA7hhg
 aBTt//dBH/XNeXUowkhKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello James,

Could you comment rumors that decision about future Linux SCSI target 
subsystem is done as well as other related rumors:

1. What don't you like in the transition path for users from STGT to 
SCST, which I proposed:

  - The only people which would be affected by replacing of STGT by SCST
would be users of ibmvstgt. Other STGT users would not notice it at all. 
Thus, we should update ibmvstgt for SCST. If ibmvstgt updated for SCST, 
the update for its users would be just writing of a simple scstadmin's 
config file.

  - STGT doesn't have backend drivers, which SCST doesn't have, so
there's nothing to worry here. At max, AIO support should be added to 
fileio_tgt.

  - STGT user space targets can use SCST backend via scst_local module.
Scst_local module is ready and work very well.

The result would be very clear without any obsolete mess.

2. Don't you like something in the sysfs interface SCST has?

3. I have heard you said "Vlad wasn't comfortable in handing up the 
control to the maintainers ... (this is how kernel.org works)." I have 
no idea what you meant. I have never been asked about anything like 
that, so I couldn't say anyhow that I'm not comfortable with anything. 
Could you clarify that?

4. Have you changed your opinion that a driver level multipath is 
forbidden in Linux and now you think that an iSCSI target with MC/S 
support is acceptable?

Thanks,
Vlad

