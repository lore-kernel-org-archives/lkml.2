Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965068Ab2EWDbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:31:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62646 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844Ab2EWDbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:31:00 -0400
Date: Tue, 22 May 2012 20:30:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: ethan zhao <ethan.kernel@gmail.com>
cc: linux-kernel@vger.kernel.org, Kurt Garloff <kurt@garloff.de>,
        Len Brown <len.brown@intel.com>
Subject: Re: ACPI and NUMA guys, please help to check if this patch is OK
In-Reply-To: <CABawtvNSYENtrJTaB5Vfd+j5MahE=xv4Ueb6-zmd1CHShuU0iQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205222029590.28165@chino.kir.corp.google.com>
References: <CABawtvNSYENtrJTaB5Vfd+j5MahE=xv4Ueb6-zmd1CHShuU0iQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, ethan zhao wrote:

> [PATCH] drivers/acpi/numa.c: Add localities checking code against
> proximity domains to slit_valid()
> 
>  Some buggy BIOS/ACPI will set different number to SLIT localities and
> SRAT proximity domains,
>  That will make NUMA configuration invalid and kernel will output
> information like following
> 
> NUMA:Warning:invalid distance parameter, from=-1 to=-1 distance=83
> 
> This patch adds some checking code to slit_valid() function in order
> to check theSLIT localities
> count against SRAT proximity domains number and give clear information
> about ACPI bug.
> 
> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>

There's nothing in the ACPI spec that prohibits this and the result is 
non-fatal (it only emits a warning of the mismatch), so this patch is 
unnecessary.
