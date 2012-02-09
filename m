Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2BIDg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 22:36:27 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46724 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab2BIDgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 22:36:25 -0500
Message-ID: <4F333F34.4020007@gmail.com>
Date: Wed, 08 Feb 2012 20:36:20 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] KVM: perf: kvm events analysis tool
References: <4F3121DE.7020502@linux.vnet.ibm.com> <4F31225C.1020703@gmail.com> <4F316596.3060509@gmail.com> <4F3212CA.4080208@linux.vnet.ibm.com> <4F32861C.5020907@gmail.com> <4F333877.8050508@linux.vnet.ibm.com>
In-Reply-To: <4F333877.8050508@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/08/2012 08:07 PM, Xiao Guangrong wrote:
> Thanks for your review and explanation!
> 
> The code of commit_pager_choice():
> static void commit_pager_choice(void)
> {
> 	switch (use_pager) {
> 	case 0:
> 		setenv("PERF_PAGER", "cat", 1);
> 		break;
> 	case 1:
> 		/* setup_pager(); */
> 		break;
> 	default:
> 		break;
> 	}
> }
> 
> setup_pager() is not called.
> 
> And it looks like kvm-events can not show the result properly if
> i try to remove setup_pager.
> 
> 

You're right; I blew right past the fact that it is a comment.

