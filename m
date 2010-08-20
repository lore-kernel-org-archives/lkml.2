Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab0HTI5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:57:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48063 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0HTI5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:57:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 Aug 2010 17:51:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Jens Axobe <jaxboe@fusionio.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        Andrea Righi <righi.andrea@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [PATCH]Fix return code for mkdir calls
Message-Id: <20100820175148.a36ae797.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C6E4229.4050702@linux.vnet.ibm.com>
References: <4C6E4229.4050702@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 14:21:53 +0530
Ciju Rajan K <ciju@linux.vnet.ibm.com> wrote:

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
Thank you!

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

