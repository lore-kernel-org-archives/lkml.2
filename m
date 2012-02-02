Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2BBLCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 06:02:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab2BBLCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 06:02:48 -0500
Message-ID: <4F2A6D46.6010406@redhat.com>
Date: Thu, 02 Feb 2012 13:02:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [test result] dirty logging without srcu update -- Re: [RFC][PATCH]
 srcu: Implement call_srcu()
References: <1328016724.2446.229.camel@twins> <4F27F0E6.1040309@redhat.com> <1328017807.2446.230.camel@twins> <20120131222447.GH2391@linux.vnet.ibm.com> <1328091749.2760.34.camel@laptop> <4F29178A.1090306@redhat.com> <4F2918D5.4050104@redhat.com> <4F291B56.30600@oss.ntt.co.jp> <4F291B92.8070402@redhat.com> <4F291E1F.3030505@oss.ntt.co.jp> <4F293D14.5030008@redhat.com> <20120202144633.1fc9b997.yoshikawa.takuya@oss.ntt.co.jp> <4F2A611E.6090005@redhat.com> <4F2A63B9.8000405@oss.ntt.co.jp> <4F2A63C6.7030301@redhat.com> <4F2A682C.7090109@oss.ntt.co.jp>
In-Reply-To: <4F2A682C.7090109@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 12:40 PM, Takuya Yoshikawa wrote:
>
> I have one concern about correctness issue though:
>
>     concurrent rmap write protection may not be safe due to
>     delayed tlb flush ... cannot happen?

What do you mean by concurrent rmap write protection?


-- 
error compiling committee.c: too many arguments to function

