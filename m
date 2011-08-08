Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1HHVKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:10:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab1HHVK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:10:28 -0400
Date: Mon, 8 Aug 2011 17:10:21 -0400
From: Dave Jones <davej@redhat.com>
To: joni@shade-fx.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand ignore_nice_level
Message-ID: <20110808211021.GA12293@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, joni@shade-fx.com,
	linux-kernel@vger.kernel.org
References: <4e403bd4.5YAAoSWMDWtU5KOP%joni@shade-fx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e403bd4.5YAAoSWMDWtU5KOP%joni@shade-fx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 10:41:08PM +0300, joni@shade-fx.com wrote:
 
 > This patch add functionality for cpufreq ondemand where user can decide
 > what nice level will be ignored when ondemand governors ignore_nice_load 
 > is used. The patch introduces new file ignore_nice_level where nice level can 
 > be tuned. In other words, user can select processes which can raise cpu
 > speed by setting processes to certain nice level and tuning ignore level
 > via ignore_nice_level at /sys/devices/system/cpu/cpufreq/ondemand .
 > 
 > To achieve this, the patch add a new nicevalue[40] array for cpu_usage_stat
 > struct where it keeps cpu usage statistic for each nice value.
 > This patch also makes this array visible for user via /proc/stat .
 > /proc/stat file gets a couple of new lines which corresponds used cpu time
 > for each nice level and for each cpu core.
 
I'm reluctant to add yet another set of knobs to tweak unless it's something that
people are really going to use. 

If there's a real use-case for this, that ignore_nice_load doesn't already provide,
I could be swayed, but I'm not really seeing it.

	Dave

