Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1CXMPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:15:43 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:55858 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752353Ab1CXMPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 08:15:41 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] APM: delete APM in Linux-2.6.40
Date: Thu, 24 Mar 2011 13:15:34 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.02.1103232321070.3848@x980> <20110324154505.934a56a0.sfr@canb.auug.org.au> <alpine.LFD.2.02.1103240336590.4529@x980>
In-Reply-To: <alpine.LFD.2.02.1103240336590.4529@x980>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103241315.34722.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 March 2011, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  Documentation/feature-removal-schedule.txt |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/feature-removal-schedule.txt
> b/Documentation/feature-removal-schedule.txt index b3f35e5..2a03c46 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -619,3 +619,11 @@ Why:	The original implementation of memsw feature
> enabled by Who:	Michal Hocko <mhocko@suse.cz>
>
>  ----------------------------
> +
> +What:	CONFIG_APM
> +When:	2.6.40
> +Why:	Microsoft deleted APM from Windows as of Vista in in 2006.
> +	It now seems more than safe that the latest Linux Kernel be APM-free.
> +	The vintage laptops supporting APM are now difficult to find,
> +	making it problatic to maintain this code.
> +Who:	Len Brown <len.brown@intel.com>

Please don't turn Linux into second Windows. If you don't want APM in the 
kernel, just don't compile it. There are many people using older systems with 
APM - and most of them wouldn't oppose to this removal as they don't even 
know about it.

-- 
Ondrej Zary
