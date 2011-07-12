Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab1GLBNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 21:13:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:60263 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab1GLBNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 21:13:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,517,1304319600"; 
   d="scan'208";a="24687127"
Message-ID: <4E1B9FA2.7090602@intel.com>
Date: Tue, 12 Jul 2011 09:13:06 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110606 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Drunkard Zhang <gongfan193@gmail.com>
CC: Borislav Petkov <bp@amd64.org>, Greg KH <gregkh@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        "Brown, Len" <len.brown@intel.com>
Subject: Re: 2.6.39.2: duplicate filename '/devices/platform/GHES.9' on Asus
 DSBV-D
References: <CAJiejCSObv6d2EULVnCufGMHsLacSi-g2o9gbs8p0MYoYMVgJg@mail.gmail.com> <20110708134003.GA5041@suse.de> <20110708142453.GA15256@gere.osrc.amd.com>
In-Reply-To: <20110708142453.GA15256@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Drunkard,

On 07/08/2011 10:24 PM, Borislav Petkov wrote:
> On Fri, Jul 08, 2011 at 06:40:03AM -0700, Greg KH wrote:
>> On Fri, Jul 08, 2011 at 04:02:27PM +0800, Drunkard Zhang wrote:
>>> On newly updated kernel I found this. I'm not sure it's a BIOS bug or
>>> kernel bug. More infomation attached. I can gather more infomation if
>>> you want :)
>>
>> It's an acpi issue, care to send it to that mailing list?
> 
> We had this issue already: http://lkml.org/lkml/2010/9/17/116 - I
> guess the fix wasn't complete. And yes, it is a BIOS bug but the
> kernel shouldn't OOPS just because BIOS programmers fell asleep on the
> keyboard.
> 
> Adding some more people to Cc.
> 

This bug has been reported and resolved in following bugzilla entry already.

https://bugzilla.kernel.org/show_bug.cgi?id=37412

We have the bugfix patch, just have not made it into upstream yet.

Best Regards,
Huang Ying
