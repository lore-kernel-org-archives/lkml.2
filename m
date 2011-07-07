Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1GGPzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:55:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49586 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1GGPzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:55:18 -0400
Date: Thu, 7 Jul 2011 08:55:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Alan Cox <alan@linux.intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 7 (i915 + gma500)
Message-Id: <20110707085501.61e86cd8.randy.dunlap@oracle.com>
In-Reply-To: <20110707172544.867b980a1196db005b577c14@canb.auug.org.au>
References: <20110707172544.867b980a1196db005b577c14@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E15D6E1.01E5:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011 17:25:44 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> The next linux-next release will (probably) be next-20110718.
> 
> Changes since 20110706:


when both CONFIG_DRM_I915=y and CONFIG_DRM_PSB=y:

drivers/staging/built-in.o: In function `intel_opregion_init':
(.text+0x47943): multiple definition of `intel_opregion_init'
drivers/gpu/built-in.o:(.text+0x17277a): first defined here

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
