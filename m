Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2KIWFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:05:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55653 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab2KIWFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:05:32 -0500
Message-ID: <509D7E29.2070803@wwwdotorg.org>
Date: Fri, 09 Nov 2012 15:05:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: tegra: tamonten: Add NCT1008 temperature sensor
References: <1352498408-31955-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352498408-31955-1-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 03:00 PM, Thierry Reding wrote:
> The Tamonten SOM has an ON Semiconductor NCT1008 connected to the DVC
> bus which is used to measure the ambient (local) temperature as well as
> the on-die (remote) temperature.

Thanks, applied to Tegra's for-3.8/dt branch.

