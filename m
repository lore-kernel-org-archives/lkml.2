Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab2KOW0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:26:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46642 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2KOW0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:26:32 -0500
Message-ID: <50A56C16.3090009@wwwdotorg.org>
Date: Thu, 15 Nov 2012 15:26:30 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Device tree updates for host1x support
References: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 02:07 PM, Thierry Reding wrote:
> This second version of this patch series splits the patches up into more
> logical chunks as requested by Stephen. Instead of renaming the matching
> parameters in the clock driver, this version renames the AUXDATA entries
> to match what the clock driver expects. Furthermore the host1x clock is
> initialized to 150 MHz instead of the unsupported 144 MHz.

Thanks very much. I have applied the series; DT changes to for-3.8/dt,
and the other changes to for-3.8/soc.
