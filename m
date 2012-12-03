Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2LCAzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 19:55:24 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42925 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab2LCAzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 19:55:22 -0500
X-AuditID: 85900ec0-d5e7ab900000152f-b3-50bbf8789cfc
Message-ID: <50BBF877.9080801@hitachi.com>
Date: Mon, 03 Dec 2012 09:55:19 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: Re: Re: Re: Re: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output
 TSC offset
References: <20121116191537.GB28622@amt.cnet> <50AB5D31.7060305@hitachi.com> <20121120225148.GA6027@amt.cnet> <50ADB650.8080502@hitachi.com> <20121123224608.GA23093@amt.cnet> <50B34CE6.9070207@hitachi.com> <20121126231653.GA20391@amt.cnet> <50B49BBB.1020204@hitachi.com> <20121129225126.GA28555@amt.cnet> <50B80DAB.4030908@hitachi.com> <20121130204240.GC22662@amt.cnet>
In-Reply-To: <20121130204240.GC22662@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

>>> That is, you can't feed distinct instances of guest kernel trace.
>>
>> I'm not clear for "distinct instances". Is this about SMP or multiple
>> guests? Would you explain about this?
>
> Distinct boot instances. If the guest reboots TSC can be written to.

OK, I understood.
I'll resend a patch series for this feature.

Thanks!

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
