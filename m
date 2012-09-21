Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2IUPLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:11:04 -0400
Received: from mail.x86-64.org ([217.9.48.20]:50898 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074Ab2IUPLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:11:01 -0400
Date: Fri, 21 Sep 2012 17:10:54 +0200
From: Borislav Petkov <bp@amd64.org>
To: Josh Hunt <johunt@akamai.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
Message-ID: <20120921151054.GB28597@aftab.osrc.amd.com>
References: <20120912164843.GC12103@aftab.osrc.amd.com>
 <5050BF1F.1080503@akamai.com>
 <20120912170629.GD12103@aftab.osrc.amd.com>
 <20120912172351.GE12103@aftab.osrc.amd.com>
 <50532940.10201@akamai.com>
 <50534184.1050208@akamai.com>
 <20120921123645.GD26869@aftab.osrc.amd.com>
 <505C6558.1040405@akamai.com>
 <20120921140133.GA27890@aftab.osrc.amd.com>
 <505C7F91.4040100@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505C7F91.4040100@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 09:54:09AM -0500, Josh Hunt wrote:
> So this is correct now:
> root@x.x.x.x:/sys/devices/system/edac/mc/mc0# grep . csrow*/size_mb
> csrow0/size_mb:1024
> csrow1/size_mb:1024
> csrow2/size_mb:1024
> csrow3/size_mb:1024

Ok, that's the same box where free reports 4G. Btw, it is in dmesg too:

[    0.000000] TOM2: 0000000112000000 aka 4384M

> But this is not:
> root@x.x.x.x:/sys/devices/system/edac/mc/mc0# grep . size_mb
> 8192
> 
> Attached patch seems to resolve reading size_mb from the mc in
> sysfs. I'm also attaching the new dmesg.

Yes, looks good. Will add it to my queue.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
