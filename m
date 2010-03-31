Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab0CaGny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:43:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35942 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab0CaGnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:43:52 -0400
Message-ID: <4BB2EEE1.4010904@zytor.com>
Date: Tue, 30 Mar 2010 23:42:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Borislav Petkov <bp@amd64.org>, davej@redhat.com, trenn@suse.de,
       linux@dominikbrodowski.net, mingo@elte.hu, tglx@linutronix.de,
       cpufreq@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [-v2 PATCH 2/6] powernow-k8: Add core performance boost support
References: <1269610800-23847-1-git-send-email-bp@amd64.org>	<1269610800-23847-3-git-send-email-bp@amd64.org>	<20100330154229.dc8ebd24.akpm@linux-foundation.org>	<20100331061343.GA28659@aftab>	<20100330232221.826fe933.akpm@linux-foundation.org>	<20100331063546.GB28659@aftab> <20100330233851.17370621.akpm@linux-foundation.org>
In-Reply-To: <20100330233851.17370621.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 08:38 PM, Andrew Morton wrote:
> 
> I've unilaterally decided that all six patches should be merged via the
> x86 tree, btw.  They could be split between x86 and cpufreq, but I
> suspect there are interdependencies which would make that hard.
> 

I would agree with that.  I'll try to get them in tomorrow.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

