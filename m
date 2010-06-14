Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0FNHyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:54:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35168 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0FNHyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:54:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 14 Jun 2010 16:49:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] Linux/Guest unmapped page cache control
Message-Id: <20100614164952.529e081a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100614073646.GS5191@balbir.in.ibm.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	<20100608155146.3749.67837.sendpatchset@L34Z31A.ibm.com>
	<20100613183145.GM5191@balbir.in.ibm.com>
	<20100614092819.cb7515a5.kamezawa.hiroyu@jp.fujitsu.com>
	<20100614064955.GR5191@balbir.in.ibm.com>
	<20100614160021.7febbdb2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100614073646.GS5191@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 13:06:46 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
 
> > It sounds that what you want is to improve performance etc. but to make it
> > easy sizing the system and to help admins. Right ?
> >
> 
> Right, to allow freeing up of using double the memory to cache data.
>  
Oh, sorry. ask again..

It sounds that what you want is _not_ to improve performance etc. but to make it
...

?

-Kame

