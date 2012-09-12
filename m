Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2ILIwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:52:12 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52632 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab2ILIwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:52:00 -0400
Date: Wed, 12 Sep 2012 10:51:40 +0200
From: Borislav Petkov <bp@amd64.org>
To: Josh Hunt <johunt@akamai.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
Message-ID: <20120912085140.GA12277@aftab.osrc.amd.com>
References: <1347403947-20187-1-git-send-email-johunt@akamai.com>
 <504FC2E9.4010708@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504FC2E9.4010708@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 06:02:01PM -0500, Josh Hunt wrote:
> On 09/11/2012 05:52 PM, Josh Hunt wrote:
> >With recent kernels we noticed that edac was reporting double the memory size on
> >systems running with AMD family 0Fh processors. I'm not very familiar with the
> >code, but this resolves it from what I can see on my systems. At least in
> >amd64_debug_display_dimm_sizes() and k8_dbam_to_chip_select() there appeared
> >to be redundant shifts to the left by 1 when WIDTH_128 is present.

Any chance you could enable CONFIG_EDAC_DEBUG, boot and send me your
whole dmesg? Privately is fine too.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
