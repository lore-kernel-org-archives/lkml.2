Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1H2B1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 21:27:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:12226 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1H2B1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 21:27:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="42820248"
Message-ID: <4E5AEAF4.3000800@intel.com>
Date: Mon, 29 Aug 2011 09:27:16 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Pavel Ivanov <paivanof@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
Subject: Re: APEI: Can not request iomem region for GARs
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com> <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com> <4E520149.3010802@intel.com> <CAG1a4rtMnDXSGLkmwE+6N9smoghWp0W4b5-X_gogzJ9fDLTeBg@mail.gmail.com> <4E571D66.1070302@intel.com> <CAErSpo5L1X49hfeJ69o_hwfuzMT6R+7TKhGbYCkyqtqVpf4tEw@mail.gmail.com>
In-Reply-To: <CAErSpo5L1X49hfeJ69o_hwfuzMT6R+7TKhGbYCkyqtqVpf4tEw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 09:43 PM, Bjorn Helgaas wrote:
> On Thu, Aug 25, 2011 at 10:13 PM, Huang Ying <ying.huang@intel.com> wrote:
>> Hi, Pavel,
>>
>> Sorry,  there is a minor issue in the patch.  Do you have time to try
>> the updated version attached.
> 
> I think Yinghai's patch is a better approach (though it needs a changelog).
> 
> The ACPI NVS space should not be marked as "busy" by the e820 code in
> the iomem_resource tree.
> 
> It's way too complicated to mess around with registering NVS space and
> trying to deal with it specially in APEI.

ACPI NVS is different, it can be used only by firmware, and its
interpreter, such as ACPI AML interpreter and APEI interpreter.  It can
not be used by ordinary driver.  If my understanding is correct, this is
why ACPI NVS is marked as busy.

Best Regards,
Huang Ying
