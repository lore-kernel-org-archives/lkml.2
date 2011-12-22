Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1LVQCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:02:01 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35227 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1LVQB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:01:58 -0500
Message-ID: <4EF35474.2010209@gmail.com>
Date: Thu, 22 Dec 2011 10:01:56 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: devicetree-discuss@lists.ozlabs.org, shawn.guo@freescale.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] dt: reform for_each_property to for_each_property_of_node
References: <1324556364-26188-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1324556364-26188-1-git-send-email-b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2011 06:19 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Make this macro easier to use(do not need to pass properties, a node is
> enough), also change to a more sensible name as for_each_child_of_node.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> ---
> Changes v1->v2:
> - Fix a typo error (micro->macro)
> 

Applied.

Rob
