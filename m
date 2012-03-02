Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab2CBJ5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:57:55 -0500
Received: from mx0.aculab.com ([213.249.233.131]:51523 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755603Ab2CBJ5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:57:53 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] powerpc/srio: Fix the compile errors when building with 64bit
Date: Fri, 2 Mar 2012 09:57:01 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E8B@saturn3.aculab.com>
In-Reply-To: <1330672127-22172-1-git-send-email-Gang.Liu@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] powerpc/srio: Fix the compile errors when building with 64bit
Thread-Index: Acz4Q5iTXw6U0OlcQUeiLtslOSAZDgAFwPRw
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Liu Gang" <Gang.Liu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <Alexandre.Bounine@idt.com>
Cc: "Shaohui Xie" <Shaohui.Xie@freescale.com>, <r61911@freescale.com>,
        <linux-kernel@vger.kernel.org>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        <akpm@linux-foundation.org>, <r58472@freescale.com>
X-OriginalArrivalTime: 02 Mar 2012 09:57:01.0929 (UTC) FILETIME=[D0B6D590:01CCF85A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> For the file "arch/powerpc/sysdev/fsl_rmu.c", there will be 
> some compile errors while using the corenet64_smp_defconfig:

I'm sure that replacing 'u32' with 'unsigned long'
is really the best thing to do here.
It looks to me as though they should be some pointer type.

	David


