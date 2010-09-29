Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0I2OwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:52:11 -0400
Received: from rcpt-mqugw.biglobe.ne.jp ([133.205.19.70]:47001 "EHLO
	rcpt-mqugw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0I2OwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:52:09 -0400
X-Greylist: delayed 2894 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2010 10:52:09 EDT
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Wed, 29 Sep 2010 23:06:54 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] memcg: fix thresholds with use_hierarchy == 1
Message-Id: <20100929230654.d7f20d2c.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20100929230252.f593abb1.d-nishimura@mtf.biglobe.ne.jp>
References: <1285763245-19408-1-git-send-email-kirill@shutemov.name>
	<20100929230252.f593abb1.d-nishimura@mtf.biglobe.ne.jp>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you can simplify this part by using parent_mem_cgroup() like:
> 
> 	parent = parent_mem_cgroup(memcg);
> 	if (!memcg)
           ^^^^^^^^ must be !parent of course :)
