Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066Ab0HFVMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 17:12:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35355 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964820Ab0HFVMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 17:12:47 -0400
Message-ID: <4C5C7AC8.9050307@zytor.com>
Date: Fri, 06 Aug 2010 14:12:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: - <kd6lvw@yahoo.com>, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [00/38] 2.6.35.1-stable review
References: <512689.43589.qm@web84207.mail.re3.yahoo.com> <20100806203443.GA24060@suse.de>
In-Reply-To: <20100806203443.GA24060@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 01:34 PM, Greg KH wrote:
> On Fri, Aug 06, 2010 at 01:22:10PM -0700, - wrote:
>> Does not include the fix to this bug (introduced in 2.6.35.0):
>>
>>     https://bugzilla.kernel.org/show_bug.cgi?id=16506
>>
>> Affected file:  arch/x86/lib/atomic64_386_32.S
>>
>> This issue causes a compile-time blocking failure.  The patch fixes the problem for older versions of BINUTILS equal to or more recent than the minimum required version currently listed in file Documentation/Changes.
>>
>> Patch:  https://bugzilla.kernel.org/attachment.cgi?id=27360
>>
>> Please include this in 2.6.35.1 and any other affected kernels.
>>
>> The problem was introduced on February 24 through March 1, 2010 by multiple commits, starting with commit a7e926abc3adfbd2e5e20d2b46177adb4e313915.
>>
>
> Which exact patch that is in Linus's tree fixes the problem?  Do you
> have the git commit id of it?  That's what I need here.
>

Not upstream just yet.

	-hpa
