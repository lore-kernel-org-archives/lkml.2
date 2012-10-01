Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab2JAWJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:09:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46483 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2JAWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:09:05 -0400
Message-ID: <506A147E.3040309@wwwdotorg.org>
Date: Mon, 01 Oct 2012 16:09:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] MAINTAINERS: add scripts/dtc under Devicetree maintainers
References: <1349124546-16864-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1349124546-16864-1-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 02:49 PM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> scripts/dtc has no explicit in kernel maintainer, so add it under
> Devicetree maintainers.

> diff --git a/MAINTAINERS b/MAINTAINERS

>  F:	Documentation/devicetree
>  F:	drivers/of
>  F:	include/linux/of*.h
> +	scripts/dtc

Doesn't that new line need to start with "F:" too?
