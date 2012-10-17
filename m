Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2JQPle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:41:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59799 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2JQPld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:41:33 -0400
Message-ID: <507ED1A9.1040605@wwwdotorg.org>
Date: Wed, 17 Oct 2012 09:41:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pritesh Raithatha <praithatha@nvidia.com>, linus.walleij@linaro.org
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        swarren@nvidia.com, dong.aisheng@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt: Document: correct tegra20/30 pinctrl slew-rate
 name
References: <1350473820-25662-1-git-send-email-praithatha@nvidia.com>
In-Reply-To: <1350473820-25662-1-git-send-email-praithatha@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 05:37 AM, Pritesh Raithatha wrote:
> change nvidia,slew_rate* to nvidia,slew-rate*

The series,

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

Linus, I assume these will go through the pinctrl tree? If you could add
Cc: stable when you commit it, that'd be useful too. thanks.
