Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2KZTeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:34:03 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46134 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab2KZTeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:34:01 -0500
Message-ID: <50B3C426.4020605@wwwdotorg.org>
Date: Mon, 26 Nov 2012 12:33:58 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] memory: tegra30: Fix warning w/o PM_SLEEP
References: <1353501740-25420-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1353501740-25420-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 05:42 AM, Hiroshi Doyu wrote:
> Fix build warning w/o PM_SLEEP.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

I assume Greg will take this through his tree.

> Change-Id: I713f7dd697f1ad9fb1fee56b389b0d6c45bb540c

But that shouldn't be there though...
