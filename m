Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab2KIWFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:05:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56655 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2KIWFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:05:43 -0500
Message-ID: <509D7E35.5070004@wwwdotorg.org>
Date: Fri, 09 Nov 2012 15:05:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: ventana: Add NCT1008 temperature sensor
References: <1352498481-32032-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352498481-32032-1-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 03:01 PM, Thierry Reding wrote:
> The Harmony board has an ON Semiconductors NCT1008 temperature sensor
> connected to the DVC bus. It can be used to monitor the ambient (local)
> and on-die (remote) temperatures.

Thanks, applied to Tegra's for-3.8/dt branch.


