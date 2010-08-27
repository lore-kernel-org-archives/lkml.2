Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab0H0GfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 02:35:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51800 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab0H0Ge6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 02:34:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 27 Aug 2010 15:29:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Mark Hills <mark@pogo.org.uk>, linux-kernel@vger.kernel.org,
        balbir@linux.vnet.ibm.com
Subject: Re: cgroup: rmdir() does not complete
Message-Id: <20100827152958.b7372adf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz>
	<20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp>
	<20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100827123948.b4427a15.nishimura@mxp.nes.nec.co.jp>
	<20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 14:42:25 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
 
> > I've run it on RHEL6-based kernel/ext3 for about one hour, but
> > I cannot reproduce it yet.
> > 
> 
> Hmm...I'll dig more. Maybe I need to use stock kernel rather than -mm...
> 
> 
Sorry, my test just hangs on -mm + (other patches)
no troubles on 2.6.34 and 2.6.36-rc1.

Where can I see  2.6.33.6(Fedora) kernel ?

Thanks,
-Kame

