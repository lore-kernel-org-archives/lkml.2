Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab0DGRQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:16:01 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:46343 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073Ab0DGRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:15:58 -0400
Date: Wed, 7 Apr 2010 10:15:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 7 (other build fixes)
Message-Id: <20100407101546.0c41e418.randy.dunlap@oracle.com>
In-Reply-To: <20100407174123.81b32310.sfr@canb.auug.org.au>
References: <20100407174123.81b32310.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BBCBDC7.004B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010 17:41:23 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100401:
> 
> My fixes tree contains:
> 	a patch for a pktcdvd build error from Arnd Bergmann
> 	a fix for the commit that broke virtual consoles on PowerPC


My fixes series (not-a-tree) contains:
. build fix for gspca=m, INPUT=[mn] (from me)
. build fix for hid-picolcd=y and other dependencies=m (from bonbons@linux-vserver.org)
. build fix for staging/dt3155/ when builtin (from me)
. build fix for usbserial generic.c when CONFIG_MAGIC_SYSRQ is not enabled (from me)
. build fix for xen/manage.c when CONFIG_MAGIC_SYSRQ is not enabled (from me)


---
~Randy
