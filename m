Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0H1UdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 16:33:01 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44617 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0H1Uc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 16:32:56 -0400
Message-ID: <4C797273.2030601@canonical.com>
Date: Sat, 28 Aug 2010 13:32:51 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Comments to apparmor Makefile (and security/Makefile)
References: <20100828070305.GA8842@merkur.ravnborg.org> <4C795F6F.40202@canonical.com> <20100828192155.GA9287@merkur.ravnborg.org>
In-Reply-To: <20100828192155.GA9287@merkur.ravnborg.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2010 12:21 PM, Sam Ravnborg wrote:
>>
>>> 8) From security/Makefile:
>>>
>>>     obj-$(CONFIG_SECURITY_APPARMOR)         += apparmor/built-in.o
>>> This is _not_ how we do it.
>>>
>>> We say just:
>>>
>>>     obj-$(CONFIG_SECURITY_APPARMOR)         += apparmor/
>>>
>>> [security/Makefile has this issue in several places]
>>>
>> okay, I set it up this way to conform to other entries in the file
>> If we are going to fix apparmor's entry we should fix them all
> 
> Agreed - its better to fix them all in one go.
> I assume you do this in a follow-up patch - it is straightforward.
> 

Yes, I was planning to submit as a separate patch.

thanks
john
