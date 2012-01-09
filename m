Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2AIPkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:40:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8668 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab2AIPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:40:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Jan 2012 07:40:10 -0800
Date: Mon, 9 Jan 2012 17:40:03 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "open list:TEGRA SUPPORT" <linux-tegra@vger.kernel.org>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v2 0/3] Tegra30 clockframework
Message-ID: <20120109154003.GW32619@tbergstrom-lnx.Nvidia.com>
References: <1326123224-32522-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1326123224-32522-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 04:33:38PM +0100, Peter De Schrijver wrote:
> This patchset introduces the tegra30 clockframework. Clocks which require
> voltage scaling are not included in this version. The implementation doesn't
> use the generic clock code yet. It's the intention to move to it, once the
> semantics are fully clarified.
> 
> ---

Some people seem to be missing. So I will send this series again. Sorry for
the noise.

Cheers,

Peter.
