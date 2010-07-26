Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0GZQRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:17:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63752 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab0GZQRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:17:06 -0400
Date: Mon, 26 Jul 2010 09:16:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 26 (xen)
Message-Id: <20100726091651.f4ed28b8.randy.dunlap@oracle.com>
In-Reply-To: <20100726154809.7f42c137.sfr@canb.auug.org.au>
References: <20100726154809.7f42c137.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C4DB4FB.01F2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010 15:48:09 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100723:
> 
> Undropped tree: xen
> 
> The xen tree lost its build problems but gained a couple more for which I
> reverted a commit and a subtreee.


when CONFIG_SMP is not enabled:

arch/x86/xen/enlighten.c:112: error: 'setup_max_cpus' undeclared (first use in this function)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
