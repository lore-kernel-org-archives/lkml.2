Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746Ab2D0Djb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:39:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36891 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759666Ab2D0Dj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:39:29 -0400
Message-ID: <4F9A14ED.1000804@landley.net>
Date: Thu, 26 Apr 2012 22:39:25 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Subodh Nijsure <snijsure@grid-net.com>
CC: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH] Recommend correct way to submit new version of the patches.
References: <1335390717-32165-1-git-send-email-snijsure@grid-net.com> <4F997B39.8020405@landley.net> <4F998DA1.8040004@grid-net.com>
In-Reply-To: <4F998DA1.8040004@grid-net.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 01:02 PM, Subodh Nijsure wrote:
...
>> Would you like me to take a stab at wordsmithing this? Something like:
>>
>>    Each patch series should ideally start with a 0/X summary message
>>    explaining the purpose of the series, with each Y/X message posted as
>>    a reply to that summary.
>>
>>    Post each new version of a patch series as its own thread. This avoids
>>    unmanageably long threads and burying new activity in old threads
>>    where it's less likely to be noticed. To reference a previous series,
>>    give a URL to a web archive, or provide the message ID, or the
>>    subject line and date of the previous posting.
>>
>> (The existing context doesn't even mention 0/5 summary messages, and the
>> hunk about "When you submit or resubmit" is up at line 101 rather than
>> down in the 580's...)
> I struggled with putting those two paragraph up at line 101 or in
> section that describes canonical patch format, decided on the later.

Maybe the file will someday need structural cleanup so there's one
obvious place to put this, but that's beyond the scope of this patch.

> Never been good at word-smithing.
> I have struggled with how does one submit patch reversions and Russell
> King described it very well on arm-linux mailing list and I thought we
> should capture this in documentation to help others that are just
> getting started with the process. Do you want me to submit v2 or you
> have it?

Did my rephrase capture what you wanted to say?

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
