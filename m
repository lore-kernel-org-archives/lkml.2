Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2KIRFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:05:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42993 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab2KIRE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:04:59 -0500
Message-ID: <509D37B8.8020606@wwwdotorg.org>
Date: Fri, 09 Nov 2012 10:04:56 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: tegra: sequence compatible strings as per preference
References: <1352452052-13823-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1352452052-13823-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 02:07 AM, Laxman Dewangan wrote:
> Sequence compatible list for tegra20-slink driver to first
> look for Tegra30 and then Tegra20. Tegra30 have additional
> feature in HW which need to be utilize if it is provided from DT.

I don't object to this patch.

However just FYI, it should not be necessary for correctness; The DT
matching order is supposed to be driven purely by the order of the
compatible values in the DT now, and not affected by the order of values
in the table. (This wasn't always the case, but was a bug that was fixed
IIRC by Thierry Reding).
