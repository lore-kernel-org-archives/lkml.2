Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab2DUEeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 00:34:36 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:55448 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2DUEef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 00:34:35 -0400
Message-ID: <4F9238D6.3030706@gmail.com>
Date: Sat, 21 Apr 2012 12:34:30 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/9] KVM: MMU: abstract spte write-protect
References: <4F911B74.4040305@linux.vnet.ibm.com> <4F911BAB.6000206@linux.vnet.ibm.com> <20120420213319.GA13817@amt.cnet> <20120421101049.421a744ba5898b6173159cb4@gmail.com>
In-Reply-To: <20120421101049.421a744ba5898b6173159cb4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 09:10 AM, Takuya Yoshikawa wrote:

> On Fri, 20 Apr 2012 18:33:19 -0300
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
>> It is preferable to remove all large sptes including read-only ones, the
>> current behaviour, then to verify that no read->write transition can
>> occur in fault paths (fault paths which are increasing in number).
>>
> 
> I think we should use separate function than spte_write_protect() for
> the large case.


I will introduce a function to handle large sptes when i implement the
idea of making writable spte to be read-only.

But, keep it in this patchset first.
