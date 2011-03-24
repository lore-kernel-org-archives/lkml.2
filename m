Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab1CXIio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:38:44 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:43440 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933710Ab1CXIil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:38:41 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] APM: delete APM in Linux-2.6.40
Date: Thu, 24 Mar 2011 09:38:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r8; KDE/4.4.5; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.02.1103232321070.3848@x980> <20110324154505.934a56a0.sfr@canb.auug.org.au> <alpine.LFD.2.02.1103240336590.4529@x980>
In-Reply-To: <alpine.LFD.2.02.1103240336590.4529@x980>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103240938.39227.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 March 2011, 08:39:07 Len Brown wrote:
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

Minor nitpick: 'in' is doubled.

Alexander
