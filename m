Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1HCFfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 01:35:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47160 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753067Ab1HCFfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 01:35:17 -0400
Date: Wed, 3 Aug 2011 14:35:11 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] cpufreq: Fix build of s3c64xx cpufreq driver for header
 change
Message-ID: <20110803053510.GB16141@opensource.wolfsonmicro.com>
References: <1311952766-11693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4E3442F9.2060901@windriver.com>
 <20110801002933.GB20641@opensource.wolfsonmicro.com>
 <20110802043853.GH11811@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802043853.GH11811@windriver.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 12:38:54AM -0400, Paul Gortmaker wrote:

> It is all taken care of, so you don't have to worry.  It isn't a change
> specific to any Samsung headers.  If you are interested to know the

I'm not worried, I'm now perfectly aware of the source of the breakage.
My goal is to make sure that you're aware that there are other patches
for this stuff that have been submitted separately which you're likely
to collide with if you're fixing these issues yourself.
