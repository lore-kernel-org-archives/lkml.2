Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab0ELRIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:08:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab0ELRIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:08:09 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: mmotm 2010-05-11-18-20 uploaded (aio build)
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
	<20100512095043.cc5d22b3.randy.dunlap@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 12 May 2010 13:07:58 -0400
In-Reply-To: <20100512095043.cc5d22b3.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Wed, 12 May 2010 09:50:43 -0700")
Message-ID: <x49bpclrqtt.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> On Tue, 11 May 2010 18:21:22 -0700 akpm@linux-foundation.org wrote:
>
>> The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
>> 
>>    http://userweb.kernel.org/~akpm/mmotm/
>> 
>> and will soon be available at
>> 
>>    git://zen-kernel.org/kernel/mmotm.git
>
>
> aio-fix-the-compat-vectored-operations.patch:
>
> (1) when CONFIG_AIO is not enabled, there are hundreds of this warning:
>
> include/linux/aio.h:226: warning: no return statement in function returning non-void
>
>
> (2) when CONFIG_AIO=y, CONFIG_IA32_EMULATION=n, CONFIG_COMPAT=n:
>
> fs/aio.c:1393: error: implicit declaration of function 'compat_rw_copy_check_uvector'

Sorry about that.  I'll fix it up, but probably can't get to it until
Monday.  Hopefully that's an ok timeframe.

Cheers,
Jeff
