Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2AIP0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:26:16 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12634 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab2AIP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:26:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 09 Jan 2012 07:26:11 -0800
Date: Mon, 9 Jan 2012 17:26:03 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "open list:TEGRA SUPPORT" <linux-tegra@vger.kernel.org>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Tegra30 clockframework
Message-ID: <20120109152603.GV32619@tbergstrom-lnx.Nvidia.com>
References: <1326121937-32054-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1326121937-32054-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 04:12:10PM +0100, Peter De Schrijver wrote:
> This patchset introduces the tegra30 clockframework. Clocks which require
> voltage scaling are not included in this version. The implementation doesn't
> use the generic clock code yet. It's the intention to move to it, once the
> semantics are fully clarified.
> 
> ---
> 
> Changes in v2:
>  * Fix parent clocks for TWD. This makes the SMP configuration booting again.
> 
> Peter De Schrijver (3):
>   ARM: tegra: add support for new clock framework features
>   ARM: tegra: implement basic tegra30 clock framework
>   ARM: tegra: enable tegra30 clock framework

Oops. Now I sent everything twice... Will send it again with the correct
topic etc.

Cheers,

Peter.
