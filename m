Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1GGJ2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:28:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1GGJ2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:28:52 -0400
Message-ID: <4E157CC6.3030107@cn.fujitsu.com>
Date: Thu, 07 Jul 2011 17:30:46 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 14/19] KVM: MMU: clean up spte updating and clearing
References: <4E0C3178.2080603@cn.fujitsu.com> <4E0C32FE.2020805@cn.fujitsu.com> <20110706173911.GA9820@amt.cnet> <4E14B511.5000408@cn.fujitsu.com> <20110707081621.GB8334@amt.cnet>
In-Reply-To: <20110707081621.GB8334@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 17:28:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 17:28:12,
	Serialize complete at 2011-07-07 17:28:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 04:16 PM, Marcelo Tosatti wrote:

>>
>> What about remove "always_track" parameter? After that, the code should be clear.
> 
> Its easier to read by having it opencoded as it is now.
> 

OK. will remove it.
