Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2JWQVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:21:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44130 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2JWQVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:21:46 -0400
Message-ID: <5086C417.102@wwwdotorg.org>
Date: Tue, 23 Oct 2012 10:21:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pavan Kunapuli <pkunapuli@nvidia.com>
CC: linux@arm.linux.org.uk, cjb@laptop.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dt: tegra: Add sdhci regulators
References: <1350976709-19248-1-git-send-email-pkunapuli@nvidia.com> <1350976709-19248-2-git-send-email-pkunapuli@nvidia.com>
In-Reply-To: <1350976709-19248-2-git-send-email-pkunapuli@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 01:18 AM, Pavan Kunapuli wrote:
> Adding vmmc and vmmcq supplies for sdhci nodes
> in tegra dt files.

As I already mentioned downstream, this patch is invalid because it will
cause runtime failures if applied before the second patch in this
series. Please see the more detailed explanation I sent downstream.
