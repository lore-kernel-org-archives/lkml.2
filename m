Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1DCPZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 11:25:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44438 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1DCPZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 11:25:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ICtaSxWd9qINgOP45cod4R0IItK5iiMt4e5TTw9lV3Pv7YOPRP+Eex4yK2PEQOzGXq
         GoXriJfvzMZCBisw9C9K6Jwxga/Knx9AUxo+vbvYclT7fdlpnmM+wVkHNGS3jCUAiog0
         6H9qYzRYmp5LYmzxXnp7Jq1NSr5kfbi5OX3Ks=
Message-ID: <4D989175.9090400@gmail.com>
Date: Sun, 03 Apr 2011 19:25:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] x86, numa_64: remove unused variable
References: <1301843624-22364-1-git-send-email-florian@mickler.org>
In-Reply-To: <1301843624-22364-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2011 07:13 PM, Florian Mickler wrote:
> In case !CONFIG_ACPI_NUMA and !CONFIG_AMD_NUMA gcc emits a warning about
> the unused variable ret.
> 
> As that variable is in fact not needed I choose to remove it.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
>  arch/x86/mm/numa_64.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 

As far as I remember David prefer to have 'ret' in place but since it causes
such a warn we better to drop it.

-- 
    Cyrill
