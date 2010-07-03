Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0GCHzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 03:55:18 -0400
Received: from ozlabs.org ([203.10.76.45]:37907 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab0GCHzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 03:55:13 -0400
From: Michael Neuling <mikey@neuling.org>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [079/200] powerpc/pseries: Make query_cpu_stopped callable outside hotplug cpu
In-reply-to: <20100703015851.GD16229@suse.de>
References: <20100701174253.083176764@clark.site> <24721.1278029718@neuling.org> <20100703015851.GD16229@suse.de>
Comments: In-reply-to Greg KH <gregkh@suse.de>
   message dated "Fri, 02 Jul 2010 18:58:51 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Sat, 03 Jul 2010 17:55:12 +1000
Message-ID: <32163.1278143712@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Greg,
> > 
> > This won't break ppc64, but it pointless without:
> > aef40e87d866355ffd279ab21021de733242d0d5 powerpc/pseries: Make
> > query_cpu_stopped callable outside hotplug cpu
> 
> That patch does not apply to the .34 tree, as it seems to be already
> included there.  If not, can you please send me a backported version?

Sorry, my bad. 

aef40e87d866355ffd279ab21021de733242d0d5 is 078/200 in this series
(seemed to escape my inbox).  All is good.

Thanks,
Mikey
