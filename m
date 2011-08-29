Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1H2FhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:37:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:1268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1H2FhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:37:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,295,1312182000"; 
   d="scan'208";a="43402522"
Message-ID: <4E5B258D.9090904@intel.com>
Date: Mon, 29 Aug 2011 13:37:17 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Pavel Ivanov <paivanof@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: APEI: Can not request iomem region for GARs
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com> <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com> <4E520149.3010802@intel.com> <CAG1a4rtMnDXSGLkmwE+6N9smoghWp0W4b5-X_gogzJ9fDLTeBg@mail.gmail.com> <4E571D66.1070302@intel.com> <CAG1a4rtckCtpNjg9ApiLt4zQWArAu7N2ivoiMjueqYDRrr-G+g@mail.gmail.com>
In-Reply-To: <CAG1a4rtckCtpNjg9ApiLt4zQWArAu7N2ivoiMjueqYDRrr-G+g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2011 11:28 AM, Pavel Ivanov wrote:
> Huang,
> 
> I can confirm that new patch got rid of the old error message but
> introduced a new one:
> 
> ERST: Failed to get Error Log Address Range
> 
> Also I noticed there's another suspicious message in dmesg and it was
> there earlier too (although it's not shown on console):
> 
> GHES: Failed to enable APEI firmware first mode
> 
> Is it bad? What does it mean?

Maybe this has been fixed, please this patch,

https://lkml.org/lkml/2011/8/11/297

Best Regards,
Huang Ying
