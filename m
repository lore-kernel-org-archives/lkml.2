Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2ITPZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:25:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42534 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab2ITPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:25:15 -0400
Message-ID: <505B3557.5000500@wwwdotorg.org>
Date: Thu, 20 Sep 2012 09:25:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt: Document general interrupt controller bindings
References: <1348143410-32656-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1348143410-32656-1-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 06:16 AM, Thierry Reding wrote:
> In order to use a device as interrupt controller, it needs to be marked
> with the DT interrupt-controller property. This commit adds rudimentary
> documentation about the required standard properties and describes the
> most commonly used interrupt specifiers.

Acked-by: Stephen Warren <swarren@nvidia.com>
