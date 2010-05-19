Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0ESSdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:33:45 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:9568 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0ESSdn convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ksrinivasan@novell.com:4:1>);
	Wed, 19 May 2010 14:33:43 -0400
Message-Id: <4BF3DAA40200003000085673@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 19 May 2010 12:33:40 -0600
From: "Ky Srinivasan" <ksrinivasan@novell.com>
To: "Greg KH" <greg@kroah.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: <hjanssen@microsoft.com>, "Avi Kivity" <avi@redhat.com>,
       <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Hyperv detection - code cleanup
References: <4BF3C97F020000300008560D@sinclair.provo.novell.com>
 <4BF424FE.80400@zytor.com> <20100519181926.GA22228@kroah.com>
 <4BF42C3D.6030404@zytor.com>
In-Reply-To: <4BF42C3D.6030404@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>> On 5/19/2010 at  2:21 PM, in message <4BF42C3D.6030404@zytor.com>, "H. Peter
Anvin" <hpa@zytor.com> wrote: 
> On 05/19/2010 11:19 AM, Greg KH wrote:
>> On Wed, May 19, 2010 at 10:50:54AM -0700, H. Peter Anvin wrote:
>>> On 05/19/2010 10:20 AM, Ky Srinivasan wrote:
>>>> From: K. Y. Srinivasan <ksrinivasan@novell.com>
>>>> Subject: Code cleanup - get rid of the "ms" prefix in hyperv related files.  
>>>>
>>>>
>>>> Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
>>>
>>> NAK in the extreme.
>>>
>>> "hyperv" -- without the capitalization to make it stand out -- is way
>>> too easy to read as just an abbreviation for "hypervisor".
>> 
>> Which is what I confused it with, and hence I wrote the ms_* changes in
>> my patch.  But KY wanted it changed back so I suggested he write a
>> patch.
>> 
>> I personally like the ms_ stuff, it makes it more obvious what is going
>> on here, but that's just me.
>> 
> 
> Well, I agree with you.  Sorry, Ky.
I see your concern.

Regards,

K. Y
> 
> 	-hpa


