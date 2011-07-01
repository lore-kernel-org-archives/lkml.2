Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1GAAr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:47:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:14305 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab1GAArZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:47:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,455,1304319600"; 
   d="scan'208";a="24985532"
Message-ID: <4E0D191C.5090208@linux.intel.com>
Date: Thu, 30 Jun 2011 17:47:24 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg Dietsche <greg@farmergreg.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, Gregory.Dietsche@cuw.edu,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86, smpboot: Mark names[] array as const
References: <1309473108-5337-1-git-send-email-Gregory.Dietsche@cuw.edu> <tip-a5fd117a8fda8621e1ae1bb3b8d55e4c0ebabd94@git.kernel.org> <4E0D1400.7020107@zytor.com> <20110701004121.GA18671@farmergreg.com>
In-Reply-To: <20110701004121.GA18671@farmergreg.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 05:41 PM, Greg Dietsche wrote:
> On Thu, Jun 30, 2011 at 05:25:36PM -0700, H. Peter Anvin wrote:
>> On 06/30/2011 05:21 PM, tip-bot for Greg Dietsche wrote:
>>> +	const char const *names[] = { "ID", "VERSION", "SPIV" };
>>         ^^^^^^^^^^^^^^^^
>>
>> Doesn't make sense, patch removed...
>> 	
> could you explain a little more? I don't see my mistake.
> it compiles and is running on my box currently.
> 

Those two "const"s are redundant.

	-hpa
