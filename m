Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab0DAB3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:29:36 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:42742 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab0DAB3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:29:32 -0400
Date: Thu, 1 Apr 2010 10:12:27 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Larry Woodman <lwoodman@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: RFC [Patch] Remove
 "please try 'cgroup_disable=memory' option if you don't want memory cgroups"
 printk at boot time.
Message-Id: <20100401101227.4e9c017d.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1270050899.3551.283.camel@dhcp-100-19-198.bos.redhat.com>
References: <1270049283.3551.281.camel@dhcp-100-19-198.bos.redhat.com>
	<1270050899.3551.283.camel@dhcp-100-19-198.bos.redhat.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Added related people to Cc list.)

On Wed, 31 Mar 2010 11:54:59 -0400, Larry Woodman <lwoodman@redhat.com> wrote:
> On Wed, 2010-03-31 at 11:28 -0400, Larry Woodman wrote:
> > We are considering removing this printk at boot time from RHEL because
> > it will confuse customers, encourage them to change the boot parameters
> > and generate extraneous support calls.  Its documented in
> > Documentation/kernel-parameters.txt anyway.  Any thoughts???
> > 
> > Larry Woodman
> > 
> 
I agree to removing this message.
We've already removed similar message about swap_cgroup in commit 627991a2.

	Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thanks,
Daisuke Nishimura.
