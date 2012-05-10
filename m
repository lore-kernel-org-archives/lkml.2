Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064Ab2EJKyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:54:35 -0400
Received: from mta114.f1.k8.com.br ([187.73.32.186]:59682 "EHLO
	mta114.f1.k8.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab2EJKyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:54:35 -0400
Message-ID: <1336647342.7710.5.camel@andre>
Subject: Re: About cgroup memory limits
From: Andre Nathan <andre@digirati.com.br>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 10 May 2012 07:55:42 -0300
In-Reply-To: <4FAB8EB5.8080901@jp.fujitsu.com>
References: <1336588657.26723.23.camel@andre>
	 <4FAB8EB5.8080901@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot Kame.

On Thu, 2012-05-10 at 18:47 +0900, KAMEZAWA Hiroyuki wrote:
> From above, rss + mapped_file == resident.

But if you check the numbers I get from memory.stat and the sum of the
statm fields for all container processes, this doesn't hold.

resident    = 28741632
rss         = 8192000
mapped_file = 3743744

Am I missing something here?

Thank you,
Andre

