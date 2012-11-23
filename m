Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2KWE3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 23:29:45 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44736 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab2KWE3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 23:29:44 -0500
MIME-Version: 1.0
In-Reply-To: <20121122112451.GE4328@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
	<b81641051dad9660b72b0028d001e5620d901160.1353560936.git.viresh.kumar@linaro.org>
	<20121122112451.GE4328@gmail.com>
Date: Fri, 23 Nov 2012 09:59:43 +0530
Message-ID: <CAKohpo=EWFNddjMNwHO4u4-bi1AQ4cvsJ4DfFOgaFv3oVfheZg@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] mfd: stmpe: Extend DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2012 16:54, Lee Jones <lee.jones@linaro.org> wrote:
>> diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
>>       stmpe1601: stmpe1601@40 {

>> +             id = <0>;
>
> Don't do this. Device IDs are Linux specific.

Hi Lee,

This is id of the mfd device that we need to pass to mfd_add_device()
and is used in following:

	pdev = platform_device_alloc(cell->name, id + cell->id);

This is required when we have multiple instances of MFD device present
on board. How do you want me to handle this ?

--
viresh
