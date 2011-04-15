Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1DOR5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:57:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44473 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab1DOR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Argp8/KSxAVyImtlzg9HY0BpnKKc2NVNlkotRmPRjXIoTfJwAQzd244sEROewcPIub
         ArVRKjXHLsFLZVWBGX77LHIj69X+CNJSTU7kBTXI98gTIWootjX8cyPXabDIq/gLfi/V
         WpVraiy3qk/jwRGXlALA4ZfjfO6IigOUrQX9I=
Message-ID: <4DA88707.4060704@garzik.org>
Date: Fri, 15 Apr 2011 13:57:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: WARNING at libata-core.c:5015 in 2.6.39-rc3-wl+, then lockup.
 (bisected)
References: <4DA5CF81.4070908@candelatech.com> <4DA5D5D8.8070301@candelatech.com> <4DA5F3BA.3060404@candelatech.com> <4DA87A72.50809@candelatech.com>
In-Reply-To: <4DA87A72.50809@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 01:03 PM, Ben Greear wrote:
> Ok, it took a while, but I think I have this thing somewhat bisected.
>
> Starting at commit 4cc4d24efce4672f9b0e7fa27963770ae602998f, I see
> hard-drive
> issues. Commits right before this (in git bisect) crash in the
> networking code
> quite often, but the hard-drive logic seems to work at least.
>
> In later builds (ie, -rc3), the crashes and warnings are different, but
> they have something to do with the file system. It's difficult to bisect
> it any better because of all the instability...
>
>
> Here are some console logs from a
> 4cc4d24efce4672f9b0e7fa27963770ae602998f boot:

(linux-ide added to CC)

hmmm...  that's a merge commit.  Any chance you could mark an individual 
commit bad, to narrow things down a bit more?  Run "git help bisect" and 
check out helpful sections "Avoiding testing a commit" and "Bisect skip".

	Jeff


