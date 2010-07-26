Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0GZGtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 02:49:16 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55559 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab0GZGtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 02:49:15 -0400
Date: Mon, 26 Jul 2010 12:19:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
        Vivek Goyal <vgoyal@redhat.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
        taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 01/11] blkiocg async: Make page_cgroup independent
 from memory controller
Message-ID: <20100726064910.GQ14369@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4C369009.80503@ds.jp.nec.com>
 <4C369431.80409@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C369431.80409@ds.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Munihiro Ikeda <m-ikeda@ds.jp.nec.com> [2010-07-08 23:14:57]:

> This patch makes page_cgroup independent from memory controller
> so that kernel functionalities other than memory controller can
> use page_cgroup.
> 
> This patch is based on a patch posted from Ryo Tsuruta on Oct 2,
> 2009 titled "The new page_cgroup framework".
> 
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
> Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>

Seems reasonable to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
-- 
	Three Cheers,
	Balbir
