Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0ESSWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:22:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58523 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0ESSWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:22:03 -0400
Message-ID: <4BF42C3D.6030404@zytor.com>
Date: Wed, 19 May 2010 11:21:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Ky Srinivasan <ksrinivasan@novell.com>, hjanssen@microsoft.com,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 2/2] Hyperv detection - code cleanup
References: <4BF3C97F020000300008560D@sinclair.provo.novell.com> <4BF424FE.80400@zytor.com> <20100519181926.GA22228@kroah.com>
In-Reply-To: <20100519181926.GA22228@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 11:19 AM, Greg KH wrote:
> On Wed, May 19, 2010 at 10:50:54AM -0700, H. Peter Anvin wrote:
>> On 05/19/2010 10:20 AM, Ky Srinivasan wrote:
>>> From: K. Y. Srinivasan <ksrinivasan@novell.com>
>>> Subject: Code cleanup - get rid of the "ms" prefix in hyperv related files.  
>>>
>>>
>>> Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
>>
>> NAK in the extreme.
>>
>> "hyperv" -- without the capitalization to make it stand out -- is way
>> too easy to read as just an abbreviation for "hypervisor".
> 
> Which is what I confused it with, and hence I wrote the ms_* changes in
> my patch.  But KY wanted it changed back so I suggested he write a
> patch.
> 
> I personally like the ms_ stuff, it makes it more obvious what is going
> on here, but that's just me.
> 

Well, I agree with you.  Sorry, Ky.

	-hpa
