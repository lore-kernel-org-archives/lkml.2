Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab1EXOqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:46:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932362Ab1EXOqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:46:11 -0400
Message-ID: <4DDBC4AC.8030906@redhat.com>
Date: Tue, 24 May 2011 17:46:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH] kvm: add missing void __user * cast to access_ok() call
References: <20110524055127.GA2460@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20110524055127.GA2460@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 08:51 AM, Heiko Carstens wrote:
> From: Heiko Carstens<heiko.carstens@de.ibm.com>
>
> fa3d315a "KVM: Validate userspace_addr of memslot when registered" introduced
> this new warning onn s390:
>
> kvm_main.c: In function '__kvm_set_memory_region':
> kvm_main.c:654:7: warning: passing argument 1 of '__access_ok' makes pointer from integer without a cast
> arch/s390/include/asm/uaccess.h:53:19: note: expected 'const void *' but argument is of type '__u64'
>
> Add the missing cast to get rid of it again...
>

Thanks, applied, and queued for 2.6.40/2.8.0/3.0/2011.1, as the case may be.

-- 
error compiling committee.c: too many arguments to function

