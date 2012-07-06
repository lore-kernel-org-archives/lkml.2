Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab2GFPof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:44:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43771 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab2GFPoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:44:34 -0400
Message-ID: <4FF707DE.60403@wwwdotorg.org>
Date: Fri, 06 Jul 2012 09:44:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, lrg@ti.com, swarren@nvidia.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V2] regulator: tps65910: add support for input supply
References: <1341564192-18154-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1341564192-18154-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 02:43 AM, Laxman Dewangan wrote:
> There is multiple voltage input pins on device which
> takes the voltage input for different voltage regulator.
> Support to configure the voltage input supplied by
> different regulator for each regulators.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
(mainly the documentation, but I briefly scanned the code)
