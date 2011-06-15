Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1FOT11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:27:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab1FOT1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:27:25 -0400
Date: Wed, 15 Jun 2011 15:26:30 -0400
From: Dave Jones <davej@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq bug fixes (stable/cpufreq.bugfixes) for 3.0 (or
 3.1).
Message-ID: <20110615192630.GC19704@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	hpa@zytor.com, x86@kernel.org, cpufreq@vger.kernel.org
References: <1308164520-14145-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308164520-14145-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 03:01:58PM -0400, Konrad Rzeszutek Wilk wrote:
 > The two patches attached make the cpufreq and powernowk8 driver more robust on
 > badly behaving machines (or hypervisors not passing through proper rmsdr calls).

I applied these (after fixing up the change of filename in the powernow driver)
I'll send Linus a pull req to make sure these get into 3.0 later.

thanks,

	Dave
