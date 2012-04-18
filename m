Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2DRIZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:25:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab2DRIZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:25:18 -0400
Message-ID: <4F8E7A5B.5030904@redhat.com>
Date: Wed, 18 Apr 2012 11:24:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        joerg.roedel@amd.com, dzickus@redhat.com, paul.gortmaker@windriver.com,
        gregkh@suse.de, ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F8D1F46.3090901@redhat.com> <4F8D4B4C.8070705@cn.fujitsu.com> <4F8D4D1C.4010400@redhat.com> <4F8E6DA5.8030503@cn.fujitsu.com>
In-Reply-To: <4F8E6DA5.8030503@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 10:30 AM, zhangyanfei wrote:
> > 
> > Okay.  Do you expect it to help in debugging the crash?  Did you have
> > cases where it would help?
> > 
>
> Yes, I do expect it to help in debugging the crash.
> Looking into host machine's crash dump, if we figure out the fact that the crash
> had happend when some host's resource was requested and used by some guset machine.
> Then, we surely want to look into the situation from guest machine's view.
>
>

What type of resource?  Can you give an example?

-- 
error compiling committee.c: too many arguments to function

