Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0H3HcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:32:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59739 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0H3HcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:32:09 -0400
Date: Mon, 30 Aug 2010 13:02:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Mark Hills <mark@pogo.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: cgroup: rmdir() does not complete
Message-ID: <20100830073200.GD32680@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz>
 <20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp>
 <20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com>
 <20100827123948.b4427a15.nishimura@mxp.nes.nec.co.jp>
 <20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>
 <20100827152958.b7372adf.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100827152958.b7372adf.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-27 15:29:58]:

> On Fri, 27 Aug 2010 14:42:25 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > > I've run it on RHEL6-based kernel/ext3 for about one hour, but
> > > I cannot reproduce it yet.
> > > 
> > 
> > Hmm...I'll dig more. Maybe I need to use stock kernel rather than -mm...
> > 
> > 
> Sorry, my test just hangs on -mm + (other patches)
> no troubles on 2.6.34 and 2.6.36-rc1.
> 
> Where can I see  2.6.33.6(Fedora) kernel ?
>

You can get the SRPM from the mirrors, one place to find it would be

http://download.fedora.redhat.com/pub/fedora/linux/updates/13/SRPMS/ 

-- 
	Three Cheers,
	Balbir
