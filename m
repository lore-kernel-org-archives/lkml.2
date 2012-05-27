Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2E0DRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 23:17:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:37804 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab2E0DRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 23:17:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148854182"
Message-ID: <4FC19C86.7040904@linux.intel.com>
Date: Sat, 26 May 2012 20:16:22 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "lkml, " <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Carmine Iascone <carmine.iascone@st.com>,
        Matteo Dameno <matteo.dameno@st.com>
Subject: Re: LIS331DLH accelerometer driver, IIO or not?
References: <4FBF0AC1.6030406@linux.intel.com> <20120525051051.GA3135@kroah.com> <4FC0C422.8080605@tremplin-utc.net> <20120526145914.47b7812d@pyramind.ukuu.org.uk>
In-Reply-To: <20120526145914.47b7812d@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/26/2012 06:59 AM, Alan Cox wrote:
>>> Make it an IIO driver and then we can delete the misc driver, which
>>> shouldn't have snuck in there in the first place :)
>>>
>>
>> To be more fair to the misc driver, I wouldn't say it snucked in there, 
>> but more "it ended up there as the least worse place" ;-)
> 
> Because IIO spent forever in staging, as well as blocking lots of other
> driver work and meaning tons of drivers are now not to be found anywhere
> but obscure git trees. Thankfully they didn't manage to block the LIS
> driver during this mess.
> 
> Until all the needed support for the LIS IIO driver exists outside of
> staging the driver needs to stay where it is and without IIO
> dependancies. It is not acceptable to cripple existing working code with
> staging tree dependencies.

Agreed. There will be a few iterations of this driver necessary before
it can replace the existing one.

> 
> Hopefully commit a980e046098b0a40eaff5e4e7fcde6cf035b7c06 has finally set
> the basis for this happening when it hits mainline.

Yes, after dusting off the 2.6.34 based IIO driver I started with and
moving it forward to 3.2, I am THRILLED to see the IIO core now in
mainline :-)

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
