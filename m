Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2JJPyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:54:07 -0400
Received: from mail.x86-64.org ([217.9.48.20]:44780 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2JJPyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:54:04 -0400
Date: Wed, 10 Oct 2012 17:53:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] Convert mce_disabled
Message-ID: <20121010155348.GE25878@aftab.osrc.amd.com>
References: <1349878801-15956-1-git-send-email-bp@amd64.org>
 <1349878801-15956-4-git-send-email-bp@amd64.org>
 <3908561D78D1C84285E8C5FCA982C28F19D49FC7@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D49FC7@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 03:46:39PM +0000, Luck, Tony wrote:
> struct mca_config {
> -	u64 dont_log_ce	: 1,
> -#define MCA_CFG_DONT_LOG_CE	0
> -	    __resv1	: 63;
> +	u64	dont_log_ce	: 1,
> +#define MCA_CFG_DONT_LOG_CE	  0
> +		mca_disabled	: 1,
> +#define MCA_CFG_MCA_DISABLED	  1
> +	    __resv1	: 62;
>  };
> 
> If we do head in this direction - I don't think it is useful to change just one bit
> on each commit. We should batch in larger groups.

Sure, this is just sanity-checking-the-approach patchset, trying to make
the intent as understandable as possible. The real thing should do a
couple of conversions in one patch, of course.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
