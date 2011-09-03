Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1ICCpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 22:45:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63690 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1ICCpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 22:45:06 -0400
MIME-Version: 1.0
In-Reply-To: <4E5B258D.9090904@intel.com>
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com>
 <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>
 <4E520149.3010802@intel.com> <CAG1a4rtMnDXSGLkmwE+6N9smoghWp0W4b5-X_gogzJ9fDLTeBg@mail.gmail.com>
 <4E571D66.1070302@intel.com> <CAG1a4rtckCtpNjg9ApiLt4zQWArAu7N2ivoiMjueqYDRrr-G+g@mail.gmail.com>
 <4E5B258D.9090904@intel.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Fri, 2 Sep 2011 22:44:33 -0400
Message-ID: <CAG1a4rtXhK-TtgayUDBK34kB2rEHUSN_6ZEX2B6Zg2-GprwCEA@mail.gmail.com>
Subject: Re: APEI: Can not request iomem region for GARs
To: Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 1:37 AM, Huang Ying <ying.huang@intel.com> wrote:
> On 08/27/2011 11:28 AM, Pavel Ivanov wrote:
>> Also I noticed there's another suspicious message in dmesg and it was
>> there earlier too (although it's not shown on console):
>>
>> GHES: Failed to enable APEI firmware first mode
>>
>> Is it bad? What does it mean?
>
> Maybe this has been fixed, please this patch,
>
> https://lkml.org/lkml/2011/8/11/297

Yes, this patch indeed fixed this failure message. It's now replaced by

GHES: APEI firmware first mode is enabled by WHEA _OSC.

Can I ask you another question: what does the following message mean?

[Firmware Warn]: GHES: Poll interval is 0 for generic hardware error
source: 1, disabled.


Pavel


P.S. No word from Asus yet on the ERST issue.
