Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab1EKPj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:39:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:33574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab1EKPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:39:44 -0400
Subject: Re: [PATCH v2] x86, vt-d: enable x2apic opt out
From: David Woodhouse <dwmw2@infradead.org>
To: Youquan Song <youquan.song@linux.intel.com>
Cc: "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Liu, Kent" <kent.liu@intel.com>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Date: Wed, 11 May 2011 16:39:38 +0100
In-Reply-To: <20110512033923.GA19708@linux-youquan.bj.intel.com>
References: <1302764783-24491-1-git-send-email-youquan.song@intel.com>
	 <1305126431.30435.163.camel@i7.infradead.org>
	 <20110512033923.GA19708@linux-youquan.bj.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1305128379.30435.171.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 04:39 +0100, Youquan Song wrote:
> The VT-d 1.3 version specification add this new feature because OEM
> request it. If OEM platform has issues to support x2apic or BIOS is 
> buggy to support x2apic, there is alternative way to opt out x2apic. 

Why not just *fix* the BIOS? Why must we hard-code workarounds into the
"hardware" specification to allow them to get away without doing their
job competently? This is madness.

Can't we just line up the substandard BIOS engineers against the wall,
and shoot them?

We should get Coreboot working on our new hardware as a matter of
course, to catch up with our main competitor and ensure that our
customers are not held hostage by these morons.

-- 
dwmw2

