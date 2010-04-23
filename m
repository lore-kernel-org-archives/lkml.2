Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0DWAYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 20:24:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47845 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab0DWAYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 20:24:06 -0400
Message-ID: <4BD0E869.10402@zytor.com>
Date: Thu, 22 Apr 2010 17:23:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH -v2 0/5] AMD L3 cache index disable fixes for .35
References: <1271945222-5283-1-git-send-email-bp@amd64.org>
In-Reply-To: <1271945222-5283-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

I get compilation failures on tip:x86/cpu with this patchset:

arch/x86/built-in.o: In function `amd_check_l3_disable':
intel_cacheinfo.c:(.cpuinit.text+0x412): undefined reference to
`num_k8_northbridges'

Both i386 and x86-64 "make allnoconfig".

	-hpa
