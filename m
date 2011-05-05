Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab1EETBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:01:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37366 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab1EETB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:01:28 -0400
Date: Thu, 5 May 2011 14:42:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com, rientjes@google.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH V2] xen/balloon: Memory hotplug support for Xen balloon
 driver
Message-ID: <20110505184202.GB10142@dumpdata.com>
References: <20110502220148.GI4623@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502220148.GI4623@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DC2EF8B.0128:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 12:01:48AM +0200, Daniel Kiper wrote:
> Memory hotplug support for Xen balloon driver. It should be
> mentioned that hotplugged memory is not onlined automatically.
> It should be onlined by user through standard sysfs interface.
> 
> This patch applies to Linus' git tree, v2.6.39-rc5 tag with a few
> prerequisite patches available at https://lkml.org/lkml/2011/5/2/339
> and at https://lkml.org/lkml/2011/3/28/98.

The patch looks good. How do I use it? Should the writeup or the
Kconfig include a little section on how to online the memory?
