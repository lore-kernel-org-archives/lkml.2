Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0ELQwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 12:52:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57044 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab0ELQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 12:52:04 -0400
Date: Wed, 12 May 2010 09:50:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: mmotm 2010-05-11-18-20 uploaded (aio build)
Message-Id: <20100512095043.cc5d22b3.randy.dunlap@oracle.com>
In-Reply-To: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BEADC82.004A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 18:21:22 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git


aio-fix-the-compat-vectored-operations.patch:

(1) when CONFIG_AIO is not enabled, there are hundreds of this warning:

include/linux/aio.h:226: warning: no return statement in function returning non-void


(2) when CONFIG_AIO=y, CONFIG_IA32_EMULATION=n, CONFIG_COMPAT=n:

fs/aio.c:1393: error: implicit declaration of function 'compat_rw_copy_check_uvector'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
