Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0IOTUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:20:09 -0400
Received: from mail.tpi.com ([70.99.223.143]:3598 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab0IOTUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:20:07 -0400
Message-ID: <4C911C60.4030105@canonical.com>
Date: Wed, 15 Sep 2010 13:20:00 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100826 Thunderbird/3.0.7
MIME-Version: 1.0
To: jbarnes@virtuousgeek.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MCP limit log messages, 2.6.36-rc4
References: <4C9106C1.4080505@canonical.com>
In-Reply-To: <4C9106C1.4080505@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2010 11:47 AM, Tim Gardner wrote:
> I've been getting regular MCP limit log messages on a Dell Studio 1458
> (i5 CPU) with an A02 BIOS. With the attached debug hack it prints the
> following values:
>
> [ 33.605098] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
> 30123, limit 1023
> [ 38.597998] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
> 21697, limit 1023
> [ 43.590917] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
> 15390, limit 1023
> [ 48.583821] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
> 43370, limit 1023
> [ 53.576740] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
> 64728, limit 1023
>
> This is an idle machine which starts printing these messages about 30
> seconds after boot. Any thoughts?
>
> rtg

More clues:

[   13.426064] intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match 
expected value (found 25, expected 35)
[   13.426086] intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[   13.426933] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp 
limit 95

-- 
Tim Gardner tim.gardner@canonical.com
