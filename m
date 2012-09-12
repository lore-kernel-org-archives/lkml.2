Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827Ab2ILRGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:06:33 -0400
Received: from mail.x86-64.org ([217.9.48.20]:56406 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760768Ab2ILRGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:06:30 -0400
Date: Wed, 12 Sep 2012 19:06:29 +0200
From: Borislav Petkov <bp@amd64.org>
To: Josh Hunt <johunt@akamai.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
Message-ID: <20120912170629.GD12103@aftab.osrc.amd.com>
References: <504FC2E9.4010708@akamai.com>
 <20120912085140.GA12277@aftab.osrc.amd.com>
 <5050824B.9050006@akamai.com>
 <5050857F.5060207@akamai.com>
 <20120912153016.GA12103@aftab.osrc.amd.com>
 <5050AC2E.3050408@akamai.com>
 <20120912154943.GB12103@aftab.osrc.amd.com>
 <5050B708.5020308@akamai.com>
 <20120912164843.GC12103@aftab.osrc.amd.com>
 <5050BF1F.1080503@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5050BF1F.1080503@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 11:58:07AM -0500, Josh Hunt wrote:
> Actually my apologies. I was looking at the 3.0 code. This issue is
> fixed in the latest kernel.
>
> Sorry for the noise on that.

That's fine. I'm happy you guys are testing this and reporting issues so
thanks anyway.

I'll ping you when I have something ready to test for the number of
pages per csrow reporting.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
