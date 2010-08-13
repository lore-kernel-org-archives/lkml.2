Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459Ab0HMOGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 10:06:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:53185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934415Ab0HMOF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 10:05:58 -0400
Message-ID: <4C6550BC.9010006@kernel.org>
Date: Fri, 13 Aug 2010 16:03:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [CPUFREQ] acpi-cpufreq: add missing __percpu markup
References: <1281708011-26583-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281708011-26583-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 13 Aug 2010 14:05:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 04:00 PM, Namhyung Kim wrote:
> acpi_perf_data is a percpu pointer but was missing __percpu markup.
> Add it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
