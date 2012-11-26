Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2KZVBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:01:19 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52687 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2KZVBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:01:17 -0500
Message-ID: <50B3D89B.8090607@wwwdotorg.org>
Date: Mon, 26 Nov 2012 14:01:15 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] amba: tegra-ahb: Fix warning w/o PM_SLEEP
References: <1353501697-25345-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1353501697-25345-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 05:41 AM, Hiroshi Doyu wrote:
> Fix build warning w/o PM_SLEEP.
> 
> Change-Id: Id5b7d089de835025b5708fa345a75990fd976363

Thanks, applied, with commit description fixed up to remove the Change-Id.

