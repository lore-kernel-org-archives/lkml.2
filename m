Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2H2Rhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:37:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43449 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2H2Rhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:37:33 -0400
Message-ID: <503E538A.4060801@wwwdotorg.org>
Date: Wed, 29 Aug 2012 10:38:18 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] regulator: tps6586x: register regulator even if no
 init data
References: <1346252473-30068-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1346252473-30068-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/12 08:01, Laxman Dewangan wrote:
> Register all TPS6586x regulators even if there is no regulator
> init data for platform i.e. without any user-supplied constraints.

I think this looks OK now, although I would like to test it, and check 
for any interactions etc. with the other TPS6586x patches, when I get 
back into the office next Tuesday.

