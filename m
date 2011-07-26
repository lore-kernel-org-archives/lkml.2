Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1GZJek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:34:40 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:48117 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1GZJec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:34:32 -0400
Message-ID: <4E2E8A23.6000601@monstr.eu>
Date: Tue, 26 Jul 2011 11:34:27 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 26
References: <20110726155744.5c1bee67177bd94211ed8c2b@canb.auug.org.au>
In-Reply-To: <20110726155744.5c1bee67177bd94211ed8c2b@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Rothwell wrote:
> Hi all,
> 
> The powerpc allyesconfig build (at least) still fails today.
> 
> Changes since 20110725:
> 
> Undropped tree: iscsi-target
> 
> Linus' tree lost its build failure but gained another for which I applied
> a patch (supplied by Linus).
> 
> The m68knommu tree lost its conflicts.
> 
> The microblaze tree gained a conflict agains Linus' tree.

Have fixed this problem by reverting one pci patch. Will wait one more day 
before I send pull request.

Thanks,
Micha


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
