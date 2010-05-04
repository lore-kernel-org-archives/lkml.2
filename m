Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737Ab0EDNw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:52:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab0EDNw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:52:56 -0400
Message-ID: <4BE02678.901@redhat.com>
Date: Tue, 04 May 2010 09:51:52 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Thomas Renninger <trenn@suse.de>, Willy Tarreau <w@1wt.eu>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       tglx@linutronix.de, davej@redhat.com, cpufreq@vger.kernel.org
Subject: Re: [PATCH 8/7] cpufreq: make the iowait-is-busy-time a sysfs tunable
References: <20100418115949.7b743898@infradead.org>	<201004231050.10667.trenn@suse.de>	<20100423090819.4273b327@infradead.org>	<201004271339.34711.trenn@suse.de> <20100503204818.7b801f43@infradead.org>
In-Reply-To: <20100503204818.7b801f43@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 11:48 PM, Arjan van de Ven wrote:

> This patch adds a sysfs tunable for the new behavior, and uses
> a very simple function to determine a reasonable default, depending
> on the CPU vendor/type.
>
> Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
