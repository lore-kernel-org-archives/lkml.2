Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0HWIyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:54:45 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41916 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab0HWIyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:54:43 -0400
Message-ID: <4C723752.4000806@fusionio.com>
Date: Mon, 23 Aug 2010 10:54:42 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ciju Rajan K <ciju@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        "taka@valinux.co.jp" <taka@valinux.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <righi.andrea@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [PATCH]Fix return code for mkdir calls
References: <4C6E4229.4050702@linux.vnet.ibm.com>
In-Reply-To: <4C6E4229.4050702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-20 10:51, Ciju Rajan K wrote:
> Hi,
> 
> This patch fixes the return value when the cgroup hierarchy for blkio 
> control groups is deeper than two levels. Right now EINVAL is returned. 
> This patch replaces EINVAL with more appropriate EPERM to align with 
> mkdir system call return values. This was discussed between Vivek and 
> Daniel sometime back. Please consider this patch for inclusion in 2.6.36.
> 
> Thanks
> Ciju
> 

Thanks, applied.

-- 
Jens Axboe

