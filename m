Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0JUCyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:54:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62700 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab0JUCyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:54:08 -0400
Message-ID: <4CBFAB7B.7080306@cn.fujitsu.com>
Date: Thu, 21 Oct 2010 10:54:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-10-20-15-01 uploaded
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
In-Reply-To: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-10-20-15-01 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.36-rc8:
> 

Got this:

arch/x86/pci/xen.c: In function 'pci_xen_init':
arch/x86/pci/xen.c:138: error: 'isapnp_disable' undeclared (first use in this function)
arch/x86/pci/xen.c:138: error: (Each undeclared identifier is reported only once
arch/x86/pci/xen.c:138: error: for each function it appears in.)

# quilt patches arch/x86/pci/xen.c
linux-next.patch
