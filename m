Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab2LJBTH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 20:19:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10059 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab2LJBTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 20:19:05 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-5f-50c538870585
From: Boojin Kim <boojin.kim@samsung.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Will Deacon'" <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <001701cdd669$19e8cdd0$4dba6970$%kim@samsung.com>
 <20121210000825.GH14363@n2100.arm.linux.org.uk>
In-reply-to: <20121210000825.GH14363@n2100.arm.linux.org.uk>
Subject: RE: [PATCH 1/3] ARM: MM: Add the workaround of Errata 774769
Date: Mon, 10 Dec 2012 10:19:03 +0900
Message-id: <002101cdd674$57884070$0698c150$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3WaqLPe5gFYt7kQTefpYQAoRl/YAABxSPA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zfd12i6MBBu+7rCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG3J+7mAv2clccWXSKuYHxOUcXIyeHhICJxJ03p5ghbDGJC/fW
	s4HYQgLLGCVWTyyDqdn1eSYTRHw6o8TlhsguRi4gex6TRFtXKyNIgk1AU2LG9+nsILaIgLnE
	vJmTmECKmAUOMUo8n3uHFaI7X+L6gxVgGzgFbCQ2b30NtllYwFXi7+GlYDUsAqoScyZOAhvE
	K2Ar0fa7ASjOAXSFusSjv7oQ840kvpxbBzaGWUBEYt+Ld4wQrQIS3yYfYoEol5XYdIAZ5AQJ
	gc9sEjdPd7JDPCMpcXDFDZYJjKKzkLQvYGRcxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRES
	yFI7GFc2WBxiFOBgVOLhDVA8GiDEmlhWXJkL9CAHs5IIL9exIwFCvCmJlVWpRfnxRaU5qcWH
	GH2ArprILCWanA+MsrySeENjYxMzE1MTc0tTc1McwkrivM0eKQFCAumJJanZqakFqUUw45g4
	OKUaGFctuVRUm9Cu82XvDqZjEaGm67kvvs7vPmb+6dRx/omXTJeYbP/4cEVQeqjS2rmre7wa
	Xl24pGe26+i2oOC6Gb69nnvNpZ09nimk7G9acPie4cVV8r86nn2Vvhw1Q0RrjVLyXqauP9fv
	67MyqthNPzp/6rvkFy6XHab+cL3BXNtyxPeeXvQV/vlKLMUZiYZazEXFiQA3sjG6kQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t9jQd12i6MBBrMPmFlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjLk/dzEX7OWuOLLoFHMD
	43OOLkZODgkBE4ldn2cyQdhiEhfurWcDsYUEpjNKXG6I7GLkArLnMUm0dbUygiTYBDQlZnyf
	zg5iiwiYS8ybOYkJpIhZ4BCjxPO5d1ghuvMlrj9YATaJU8BGYvPW18wgtrCAq8Tfw0vBalgE
	VCXmTJwENohXwFai7XcDUJwD6Ap1iUd/dSHmG0l8ObcObAyzgIjEvhfvGCcw8s9C4i5gZFzF
	KJpakFxQnJSea6hXnJhbXJqXrpecn7uJERwpz6R2MK5ssDjEKMDBqMTDG6B4NECINbGsuDIX
	6GAOZiURXq5jRwKEeFMSK6tSi/Lji0pzUosPMfoAHTiRWUo0OR8YxXkl8YbGJmZGlkZmFkYm
	5uY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1MGaz2B90/u2wumjG8ZOzRLQNRPk4N+dm
	eusq55w/d1js3qkJrRFe+rv17VZ9fXRToGKqbeqO9d42Tj8ONKQd+q66a9sBldLl/9yd9s3p
	FbycuO25lGmS3Bst/4MvZr9YMOl9esaPPj+1k19nFZzUDFfxX5R5Y8LtXyWL5nOlZHgr2kyw
	+qd1R1+JpTgj0VCLuag4EQB55sxcwQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:

> > -3:	mov	r10, #0
> > +	/* Cortex-A15 Errata */
> > +3:	ldr	r10, =0x00000c0f		@ Cortex-A15 primary part number
> > +	teq	r0, r10
> > +	bne	4f
> > +#ifdef CONFIG_ARM_ERRATA_774769
>
> There's not much point testing for the part number of the work-around isn't
> enabled.
The errata 773022 on second patch series is also required to checking the part number.
In my opinion, the testing for Cortex-A15 primary part number is required
before working the work-around to support several A15 errata.

>
> > +	teq	r6, #0x4			@ present in r0p4
> > +	mrceq	p15, 0, r10, c1, c0, 1		@ read aux control register
>
> 	tsteq	r10, #1 << 15
>
> to avoid writing to the aux control register if the errata has already been
> applied.
Do you mean "tsteq	r10, #1 << 25" ?
If yes, it needs to branch and will make a little complicated
And, I think maybe this function could be the first step to configure this erratum.

Thanks for your review

>
> > +	orreq	r10, r10, #1 << 25		@ set bit #25
> > +	mcreq	p15, 0, r10, c1, c0, 1		@ write aux control register
> > +#endif
> > +
> > +4:	mov	r10, #0
> >  	mcr	p15, 0, r10, c7, c5, 0		@ I+BTB cache invalidate
> >  	dsb
> >  #ifdef CONFIG_MMU
> > --
> > 1.7.5.4
> >
> >
> >
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


