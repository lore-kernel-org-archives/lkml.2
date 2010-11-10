Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab0KJVxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:53:38 -0500
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:33399 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756882Ab0KJVxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:53:37 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 16:53:37 EST
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: fU0zL1QVM1m9OsHIrSNI.XM7rxq8hfWBcHoZ.nml44ex1zG
 oXeN4GfM964xSky3NrpsKoZza8mjJsHxJkpgOpdJdGTAtCvJDsnLyt5LFiMb
 qYVcv2uoS.9LzHqLycYgveTCoOIauE6TIkKoelSUPlxb4ovKL0YMzGT0qbDX
 FUZR2trg.bdwl0sLStbFrURCLwSvheYQf44jm_ZZRsROULKNZhSsTuFfASEs
 -
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 10 Nov 2010 15:46:55 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: Bad page state in process (current git)
In-Reply-To: <20101110154057.GA2191@arch.trippelsdorf.de>
Message-ID: <alpine.DEB.2.00.1011101534370.30164@router.home>
References: <20101110152519.GA1626@arch.trippelsdorf.de> <20101110154057.GA2191@arch.trippelsdorf.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Markus Trippelsdorf wrote:

> I found this in my dmesg:
> ACPI: Local APIC address 0xfee00000
>  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff8800d0000000-ffff8800d39fffff] on node 0

That only shows you how the memmap was virtually mapped.
