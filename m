Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1LPKKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:10:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54386 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1LPKKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:10:13 -0500
Message-ID: <1324030209.2273.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH v2] net: fix sleeping while atomic problem in sock
 mem_cgroup.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>
Date: Fri, 16 Dec 2011 11:10:09 +0100
In-Reply-To: <4EEB1807.1000308@parallels.com>
References: <1324026582-5214-1-git-send-email-glommer@parallels.com>
	  <1324027869.2273.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <4EEB1508.3080405@parallels.com>
	 <1324029886.2273.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EEB1807.1000308@parallels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 décembre 2011 à 14:05 +0400, Glauber Costa a écrit :

> Well, in this case, I myself think this is a better solution. Do you 
> want to push the patch yourself, or should I do it ?
> 

Please do it, I'll add my SOB after yours, thanks !



