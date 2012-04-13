Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2DMRBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:01:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39733 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2DMRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:01:15 -0400
Message-ID: <4F885BD8.1030201@wwwdotorg.org>
Date: Fri, 13 Apr 2012 11:01:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hannu Heikkinen <hannuxx@iki.fi>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        a.zummo@towertech.it
Subject: Re: [PATCH] rtc: tegra: cleanup probe/remove routines
References: <1334238054-31600-1-git-send-email-hannuxx@iki.fi>
In-Reply-To: <1334238054-31600-1-git-send-email-hannuxx@iki.fi>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 07:40 AM, Hannu Heikkinen wrote:
> From: Hannu Heikkinen <ext-hannu.m.heikkinen@nokia.com>
> 
> Use the devres managed resource functions in the probe routine.
> Affects also in remove routine where previously used free and release
> functions are not needed.
> 
> The devm_* functions eliminate the need for manual resource releasing
> and simplify error handling. Resources allocated by devm_* are freed
> automatically on driver detach.
> 
> Signed-off-by: Hannu Heikkinen <ext-hannu.m.heikkinen@nokia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
