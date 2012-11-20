Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2KTIhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:37:46 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:51262 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2KTIhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:37:43 -0500
Message-ID: <50AB4156.1040509@monom.org>
Date: Tue, 20 Nov 2012 09:37:42 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/7] netprio_cgroup: shorten variable names in extend_netdev_table()
References: <1353400211-5182-1-git-send-email-tj@kernel.org> <1353400211-5182-4-git-send-email-tj@kernel.org>
In-Reply-To: <1353400211-5182-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.11.2012 09:30, Tejun Heo wrote:
> The function is about to go through a rewrite.  In preparation,
> shorten the variable names so that we don't repeat "priomap" so often.
>
> This patch is cosmetic.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Tested and Acked-by: Daniel Wagner <daniel.wagner@bmw-carit.de>

