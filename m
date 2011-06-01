Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab1FATyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:54:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab1FATyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:54:38 -0400
Date: Wed, 1 Jun 2011 15:54:18 -0400
From: Dave Jones <davej@redhat.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>, cpufreq@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] CPUFREQ/S5PV210,EXYNOS4: Add Kconfig options for S5PV210
 and EXYNOS4 CPUfreq drivers
Message-ID: <20110601195418.GA30806@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Donggeun Kim <dg77.kim@samsung.com>, cpufreq@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	Ben Dooks <ben-linux@fluff.org>
References: <1306476428-24808-1-git-send-email-dg77.kim@samsung.com>
 <1306483489-10432-1-git-send-email-dg77.kim@samsung.com>
 <4DE6977E.5080107@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE6977E.5080107@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 12:48:14PM -0700, Kukjin Kim wrote:
 
 > Dave, could you please see below? If you're ok, will submit remained
 > others for Samsung cpufreq drivers.

I'm ok with the principle of the patch, though it doesn't seem to include
any driver movement, so just applying this will break the compile.
(If it happens in another patch, they should really go together to
 not break bisecting)

	Dave


