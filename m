Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1ITJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:29:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:53294 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab1ITJ3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:29:23 -0400
Subject: Re: [PATCH 9/9] Report steal time for cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Tue, 20 Sep 2011 11:29:04 +0200
In-Reply-To: <1316030695-19826-10-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	 <1316030695-19826-10-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316510944.11841.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
> +               list_for_each_entry(sib, &ca->css.cgroup->sibling, sibling) {

Oh hey, look at that, cgroups have a sibling list as well as a parent
pointer.. good thing I duplicated all that for task_group :-)

[ sadly we can't actually remove that, because we can have groups not
represented in the cgroup muck ]
