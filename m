Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab1D1KIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab1D1KI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:08:27 -0400
Message-ID: <4DB93C95.1050506@redhat.com>
Date: Thu, 28 Apr 2011 13:08:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Make dump_vmcb static, reduce text
References: <78024a3a74353a4d73be69b4e4f42da942b8fe15.1303707337.git.joe@perches.com>
In-Reply-To: <78024a3a74353a4d73be69b4e4f42da942b8fe15.1303707337.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2011 08:00 AM, Joe Perches wrote:
> dump_vmcb isn't used outside this module, make it static.
> Shrink text and object by ~1% by standardizing formats.
>
> $ size arch/x86/kvm/svm.o*
>     text	   data	    bss	    dec	    hex	filename
>    52910	    580	  10072	  63562	   f84a	arch/x86/kvm/svm.o.new
>    53563	    580	  10072	  64215	   fad7	arch/x86/kvm/svm.o.old
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

