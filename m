Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab2KPC2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 21:28:46 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33658 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2KPC2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 21:28:45 -0500
MIME-Version: 1.0
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E346BC0674@ORSMSX101.amr.corp.intel.com>
References: <CABawtvMsrMhGL7emsvYRXrGEB9f2Pzha2+XTVSHaYw1PVJGa-Q@mail.gmail.com>
	<94F2FBAB4432B54E8AACC7DFDE6C92E346BC0674@ORSMSX101.amr.corp.intel.com>
Date: Fri, 16 Nov 2012 10:28:44 +0800
Message-ID: <CABawtvPNmOzgvsg9+y12a5ToCmV4OgKQeBAVQeRyc0F+XWmb7Q@mail.gmail.com>
Subject: Re: [PATCH ] tbfadt.c: output warning only when 64bit 32bit address
 of FACS/DSDT all have value but not equal to each other
From: Ethan Zhao <ethan.kernel@gmail.com>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob,
       Thanks for your detailed reviewing about the whole possible conditions.
       I.C.  So that is impossible zero value for Xfacs /Xdsdt if
facs/dsdt >0, for they are assigned in acpi_tb_convert_fadt(),  I need
to move my eyes one line code higher to see why it yelled twice
but not using the 32bit address at once in acpi_tb_convert_fadt().
       Do you agree to move the checking code warning  and into
acpi_tb_convert_fadt to make the code more simple and clear ? Or just
keep it for more rework, more bug?


Thanks,
Ethan
