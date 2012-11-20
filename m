Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab2KTJ6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:58:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:14933 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab2KTJ57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:57:59 -0500
X-IronPort-AV: E=Sophos;i="4.83,285,1352044800"; 
   d="scan'208";a="6238865"
Message-ID: <50AB53B8.1030309@cn.fujitsu.com>
Date: Tue, 20 Nov 2012 17:56:08 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] x86: clear vmcss on all cpus when doing kdump
 if necessary
References: <50A3645F.60302@cn.fujitsu.com> <50A611AA.6030903@cn.fujitsu.com> <20121120003258.GA1292@amt.cnet>
In-Reply-To: <20121120003258.GA1292@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/20 17:57:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/20 17:57:42
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月20日 08:32, Marcelo Tosatti 写道:
> On Fri, Nov 16, 2012 at 06:12:58PM +0800, zhangyanfei wrote:
>> Hello Marcelo,
>>
>> Any thoughts?
> 
> I thought a function call was OK, but its better to have all code in
> vmx.c. Please have an atomic notifier in kexec.c (registered by KVM
> module via atomic_notifier_chain_register etc).
> 
> Other than that, which is largely cosmetic, it looks fine.
> Sorry for not expressing this earlier.
> 
> 

Hmm, Thanks. I will resend a new patch set.

Thanks
Zhang
