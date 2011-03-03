Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab1CCVDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:03:39 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58541 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab1CCVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:03:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=azf942TM51L72svnrcyIeKQdAxnS1KDqrp+UfT2dyWkwz5K0fqdoYa+eE5Ic26pMwM
         WNjL+f8sfRW4MQ49abrktDt1Ca3nJnnmc22y4cUp0NBgUP8QA+7sDTmJkL3GQqpVJaf3
         Ue+3az6jNAZenxeFzID95NVaQ8CC5CBZ1QqV4=
Message-ID: <4D700223.2020700@gmail.com>
Date: Fri, 04 Mar 2011 00:03:31 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrik Kretzschmar <henne@nachtwindheim.de>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] x86: remove ancient crufty prototype
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de> <1299182701-8591-5-git-send-email-henne@nachtwindheim.de>
In-Reply-To: <1299182701-8591-5-git-send-email-henne@nachtwindheim.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 11:04 PM, Henrik Kretzschmar wrote:
> The function cache_APIC_registers() does not exist in
> the whole git history, so it can be removed.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> ---

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

-- 
    Cyrill
