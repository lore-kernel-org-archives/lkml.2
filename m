Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1ISSgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:36:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:42637 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab1ISSgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:36:02 -0400
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Mon, 19 Sep 2011 20:35:43 +0200
In-Reply-To: <4E776E36.6040906@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	   <1316030695-19826-2-git-send-email-glommer@parallels.com>
	  <1316448186.1511.19.camel@twins> <4E776937.1070108@parallels.com>
	 <1316449160.6091.5.camel@twins> <4E776E36.6040906@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316457343.6091.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 13:30 -0300, Glauber Costa wrote:
> For cpuusage, I am not sure this optimization is a valid one 

I was talking about cpuusage, cpuacct_charge() is called for every
ctxsw/tick.

But even for cpuacct tick stuff, wouldn't you need to sum all your child
cgroups to update the current cgroup? and that up the whole tree?
