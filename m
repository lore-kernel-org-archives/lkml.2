Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1DUTj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:39:26 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13623 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab1DUTj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:39:26 -0400
Message-ID: <4DB087EC.1010205@caviumnetworks.com>
Date: Thu, 21 Apr 2011 12:39:24 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: annoying new gcc 4.6.0 warnings.
References: <20110421192117.GA14249@redhat.com> <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com>
In-Reply-To: <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2011 19:39:25.0409 (UTC) FILETIME=[D21DBD10:01CC005B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 12:24 PM, Linus Torvalds wrote:
> On Thu, Apr 21, 2011 at 12:21 PM, Dave Jones<davej@redhat.com>  wrote:
>>
>> There might be some valid bugs found (I think DaveM found a few already) from this new
>> warning, but it seems like everything I've looked at so far is just noise.
>>
>> Any thoughts ?
>
> Yeah, let's just disable the crazy warning. Maybe some of them are
> valid, but it's like the f*cking sign-compare warning: most of them
> are just inane noise, and as such the warning is not worth the pain.
>
> I assume (hope) that there is some -Wno-unused-but-set-variable thing
> we could do, the same way we do -Wno-trigraphs for another totally
> useless gcc warning.
>

This particular warning has helped to find quite a bit of dead code.

Would it make any sense to add a config option to enable the spew for 
those that wanted to see it?

David Daney

