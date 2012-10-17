Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2JQFjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:39:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33800 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752415Ab2JQFjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:39:35 -0400
Message-ID: <1350452374.3072.19.camel@joe-AO722>
Subject: Re: [PATCH 1/2] cpufreq: Improve debug prints
From: Joe Perches <joe@perches.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, pdsw-power-team@arm.com
Date: Tue, 16 Oct 2012 22:39:34 -0700
In-Reply-To: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
References: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 10:50 +0530, Viresh Kumar wrote:
> With debug options on, it is difficult to locate cpufreq core's debug prints.
[]
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
[]
> @@ -15,6 +15,8 @@
> +#define pr_fmt(fmt) "cpufreq: " fmt

I'd prefer that

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

be used for all of these.

