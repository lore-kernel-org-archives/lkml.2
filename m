Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab0I3CB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:01:27 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58373 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0I3CB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:01:26 -0400
Date: Thu, 30 Sep 2010 11:01:18 +0900
From: Norbert Preining <preining@logic.at>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: high power consumption in recent kernels
Message-ID: <20100930020118.GE30836@gamma.logic.tuwien.ac.at>
References: <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com> <20100909205115.GD11053@gamma.logic.tuwien.ac.at> <1284107099.402.30.camel@laptop> <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com> <20100910145451.GB21450@gamma.logic.tuwien.ac.at> <1284355277.26157.8109.camel@debian> <20100922154452.GA9080@gamma.logic.tuwien.ac.at> <1285670426.21962.43.camel@debian> <4CA34F95.30400@logic.at> <1285807841.21962.1147.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285807841.21962.1147.camel@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 30 Sep 2010, Alex,Shi wrote:
> +               arch_needs_cpu(cpu)|| (inidle && nohz_ratelimit(cpu))) {

Sorry right, the 
	inidle
is new, missed that one. I will rebuild in a minute and test.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
AITH (n.)
The single bristle that sticks out sideways on a cheap paintbrush.
			--- Douglas Adams, The Meaning of Liff
