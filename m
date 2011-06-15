Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab1FOVNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:13:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61840 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab1FOVNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:13:43 -0400
Date: Wed, 15 Jun 2011 17:13:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq bug fixes (stable/cpufreq.bugfixes) for 3.0 (or
 3.1).
Message-ID: <20110615211319.GB27438@dumpdata.com>
References: <1308164520-14145-1-git-send-email-konrad.wilk@oracle.com>
 <20110615192630.GC19704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615192630.GC19704@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4DF9207A.00B5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 03:26:30PM -0400, Dave Jones wrote:
> On Wed, Jun 15, 2011 at 03:01:58PM -0400, Konrad Rzeszutek Wilk wrote:
>  > The two patches attached make the cpufreq and powernowk8 driver more robust on
>  > badly behaving machines (or hypervisors not passing through proper rmsdr calls).
> 
> I applied these (after fixing up the change of filename in the powernow driver)
> I'll send Linus a pull req to make sure these get into 3.0 later.

Thank you. Sorry about missing the directory move and you having to do extra legwork.
