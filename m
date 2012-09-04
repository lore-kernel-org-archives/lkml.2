Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2IDMNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:13:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab2IDMNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:13:41 -0400
Message-ID: <5045F06F.5030101@redhat.com>
Date: Tue, 04 Sep 2012 15:13:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mathias Krause <minipli@googlemail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: x86 emulator: use aligned variants of SSE register
 ops
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com> <1346283020-22385-3-git-send-email-minipli@googlemail.com> <5045EF86.4080600@redhat.com>
In-Reply-To: <5045EF86.4080600@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 03:09 PM, Avi Kivity wrote:
> On 08/30/2012 02:30 AM, Mathias Krause wrote:
>> As the the compiler ensures that the memory operand is always aligned
>> to a 16 byte memory location, 
> 
> I'm not sure it does.  Is V4SI aligned?  Do we use alignof() to
> propagate the alignment to the vcpu allocation code?

We actually do.  But please rebase the series against next, I got some
conflicts while applying.


-- 
error compiling committee.c: too many arguments to function
