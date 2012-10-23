Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab2JWKeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:34:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61283 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab2JWKeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:34:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,635,1344182400"; 
   d="scan'208";a="6052088"
Message-ID: <508672B9.8010303@cn.fujitsu.com>
Date: Tue, 23 Oct 2012 18:34:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in cmci_rediscover().
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com> <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com> <20121019164045.GE11958@aftab.osrc.amd.com> <5084AB10.7010807@cn.fujitsu.com> <20121022101442.GB8352@liondog.tnic> <50860711.10807@cn.fujitsu.com> <20121023095234.GA22715@liondog.tnic> <50866EBB.2010507@cn.fujitsu.com> <20121023102008.GB24656@liondog.tnic>
In-Reply-To: <20121023102008.GB24656@liondog.tnic>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 18:33:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 18:33:36,
	Serialize complete at 2012/10/23 18:33:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On tue, 23 Oct 2012 12:20:08 +0200, Borislav Petkov wrote:
> On Tue, Oct 23, 2012 at 06:17:31PM +0800, Miao Xie wrote:
>> This function is called after a cpu is offline, in other words, it is
>> impossible that the cpu is still in cpu_online_mask. otherwise there
>> is something wrong in the code.
> 
> And?

So we add this WARN_ON_ONCE(), it can tell the developers that there is
something wrong in the code if it is triggered.

Thanks
Miao
