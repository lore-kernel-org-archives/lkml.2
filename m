Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2GXQAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:00:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36034 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2GXQAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:00:40 -0400
Message-ID: <500EC6A6.80703@wwwdotorg.org>
Date: Tue, 24 Jul 2012 10:00:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: correct vin pin for sm0/sm1/sm2
References: <1343117880-11576-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1343117880-11576-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 02:18 AM, Laxman Dewangan wrote:
> As per datasheet, the vin pin for the regulator is named
> as vin_sm0, vin_sm1, vin_sm2 for sm0, sm1 and sm2 respectively.
> 
> Correcting the names in driver and documentation to match with
> datasheet.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Reported-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
