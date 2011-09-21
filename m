Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1IUP3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:29:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:35008 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab1IUP3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:29:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="51577270"
Message-ID: <4E7A02AF.9020106@linux.intel.com>
Date: Wed, 21 Sep 2011 08:28:47 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Richard Cochran <richardcochran@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        gthelen@google.com, tartler@cs.fau.de,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig: Add merge_config.sh script
References: <1316582561-23066-1-git-send-email-john.stultz@linaro.org>  <20110921064423.GA4103@netboy.at.omicron.at> <1316618285.3112.204.camel@work-vm>
In-Reply-To: <1316618285.3112.204.camel@work-vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/21/2011 08:18 AM, John Stultz wrote:
> On Wed, 2011-09-21 at 08:44 +0200, Richard Cochran wrote:
>> On Tue, Sep 20, 2011 at 10:22:41PM -0700, John Stultz wrote:
>>> After noticing almost every distro has their own method of managing
>>> config fragments, I went looking at some best practices, and wanted
>>> to try to consolidate some of the different approaches so this fairly
>>> simple infrastructure can be shared (and new distros/build systems
>>> don't have to implement yet another config fragment merge script).
>>
>> John,
>>
>> I have been wanting to make or find a way to start with an allnoconfig
>> and enable a short list of config options (and the options that are
>> needed to allow them). I don't want the other defaults at all.
> 
> "make oldnoconfig" provides something close to this, I think. 
> 
>> Can I use your script for this? If not, is there another way to go
>> about it?
> 
> I guess my script could take an option to use oldnoconfig instead of the
> alldefconfig method.

I had considered suggesting this as well. It would be useful for
assembling a bare minimum configuration.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
