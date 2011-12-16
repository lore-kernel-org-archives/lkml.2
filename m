Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894Ab1LPWYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:24:40 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33201 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1LPWYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:24:34 -0500
MIME-Version: 1.0
In-Reply-To: <201112162259.29043.marek.vasut@gmail.com>
References: <201112162259.29043.marek.vasut@gmail.com>
Date: Fri, 16 Dec 2011 22:24:33 +0000
X-Google-Sender-Auth: zLU0EvbQV-R_obP-We-BZLJHpfM
Message-ID: <CAAq6er31hkB++ROFdA0OxCEn9LBEW_StVa+CvMrzkKnCJayF_w@mail.gmail.com>
Subject: Re: checkpatch.pl misreporting bugs with array fillings
From: Andy Whitcroft <apw@shadowen.org>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: joe@perches.com, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 9:59 PM, Marek Vasut <marek.vasut@gmail.com> wrote:
> Hi,
>
> the following testcase is probably misreported by checkpatch.pl:
>
> static const unsigned char pci_irq_swizzle[2][PCI_MAX_DEVICES] = {
>        {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
>        {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> };
>
> The result is:
>
> ERROR: space prohibited before open square bracket '['
> #2: FILE: testcase.c:2:
> +       {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
>
> ERROR: space prohibited before open square bracket '['
> #3: FILE: testcase.c:3:
> +       {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
>
> total: 2 errors, 0 warnings, 5 lines checked
>
> NOTE: Ignored message types: COMPLEX_MACRO CONSIDER_KSTRTO MINMAX
> MULTISTATEMENT_MACRO_USE_DO_WHILE
>
> testcase.c has style problems, please review.

Hmmm will have a look...

-apw
