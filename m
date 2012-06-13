Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab2FMQBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:01:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48644 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab2FMQBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:01:02 -0400
Message-ID: <4FD8B93B.9020807@wwwdotorg.org>
Date: Wed, 13 Jun 2012 10:00:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regmap: mmio: Staticize regmap_mmio_gen_context()
References: <1339599444.8531.1.camel@phoenix>
In-Reply-To: <1339599444.8531.1.camel@phoenix>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 08:57 AM, Axel Lin wrote:
> regmap_mmio_gen_context() is only used in regmap-mmio.c. Thus make it static.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
