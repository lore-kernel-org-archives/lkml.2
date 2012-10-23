Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab2JWKUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:20:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58895 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab2JWKUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:20:10 -0400
Date: Tue, 23 Oct 2012 12:20:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, tony.luck@intel.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in
 cmci_rediscover().
Message-ID: <20121023102008.GB24656@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Tang Chen <tangchen@cn.fujitsu.com>, tony.luck@intel.com,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	laijs@cn.fujitsu.com, wency@cn.fujitsu.com, x86@kernel.org,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
 <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com>
 <20121019164045.GE11958@aftab.osrc.amd.com>
 <5084AB10.7010807@cn.fujitsu.com>
 <20121022101442.GB8352@liondog.tnic>
 <50860711.10807@cn.fujitsu.com>
 <20121023095234.GA22715@liondog.tnic>
 <50866EBB.2010507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50866EBB.2010507@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 06:17:31PM +0800, Miao Xie wrote:
> This function is called after a cpu is offline, in other words, it is
> impossible that the cpu is still in cpu_online_mask. otherwise there
> is something wrong in the code.

And?

Are you answering my question or explaining the code just for the fun of
it?

-- 
Regards/Gruss,
    Boris.
