Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343Ab2ILQsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:48:46 -0400
Received: from mail.x86-64.org ([217.9.48.20]:56105 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab2ILQso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:48:44 -0400
Date: Wed, 12 Sep 2012 18:48:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Josh Hunt <johunt@akamai.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
Message-ID: <20120912164843.GC12103@aftab.osrc.amd.com>
References: <1347403947-20187-1-git-send-email-johunt@akamai.com>
 <504FC2E9.4010708@akamai.com>
 <20120912085140.GA12277@aftab.osrc.amd.com>
 <5050824B.9050006@akamai.com>
 <5050857F.5060207@akamai.com>
 <20120912153016.GA12103@aftab.osrc.amd.com>
 <5050AC2E.3050408@akamai.com>
 <20120912154943.GB12103@aftab.osrc.amd.com>
 <5050B708.5020308@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5050B708.5020308@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 11:23:36AM -0500, Josh Hunt wrote:
> Looks like we're seeing an issue on another machine. Still 0Fh family,
> but the model is reported as 2, with cs_mode 7.

Can I have /proc/cpuinfo and full dmesg with EDAC_DEBUG enabled from
that machine please?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
