Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1BASuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:50:25 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57424 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1BASuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:50:23 -0500
Date: Tue, 1 Feb 2011 19:51:15 +0100
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EDAC-AMD64] Display correct RAM sizes in ganged mode on F10
 CPUs
Message-ID: <20110201185114.GD8418@aftab>
References: <20110129211531.GA1874@gentoo.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110129211531.GA1874@gentoo.trippels.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 29, 2011 at 04:15:31PM -0500, Markus Trippelsdorf wrote:
> The EDAC_AMD64 module displays only half the actual memory size, when
> RAM is running in ganged mode on F10 CPUs. Fix this by moving the the
> conversion factor check out of the if block, where it is never reached.
> 
> With this patch:
> 
> Unganged: 
>  amd64: DRAM ECC enabled.
>  EDAC amd64: F10h detected (node 0).
>  EDAC amd64: using x4 syndromes.
>  EDAC MC: DCT0 chip selects:
>  kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
>  kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
>  kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
>  kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
>  kernel: EDAC MC: DCT1 chip selects:
>  kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
>  kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
>  kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
>  kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
>  kernel: EDAC amd64: MCT channel count: 2

Hmm, can you send me your whole dmesg without your patch, dmidecode
output and the exact model of your DIMMs.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
