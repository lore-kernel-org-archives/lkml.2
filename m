Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0IUGoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:44:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65148 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab0IUGoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=B9d07Le0JgDmGcjteVuAEfn2JxwW20Q+SFfFBP4+xbaUCVXc8u5avxvlJVBWFMlbG1
         4VgMdK0fr+Y+1GhVBGjLtIvpoM2gNpTdC5TgorjqJgPlROJYc8va6CPGlNV2qss9GRHE
         cZ5r4jfPCLY8uATwEifrv0cGc6H7rSADtEM70=
Message-ID: <4C98543B.9070400@gmail.com>
Date: Mon, 20 Sep 2010 23:44:11 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/223] drivers/* Update broken web addresses.
References: <1284071091-7676-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1009141413290.26813@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1009141413290.26813@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 05:14 AM, Jiri Kosina wrote:
> On Thu, 9 Sep 2010, Justin P. Mattock wrote:
>
>> Below you will find patches consisting of updated web addresses to broken links found
>> in drivers/* .. I went through the best that I can for them.. some where non
>> existent, some where just a change of name, and some had a typo in them.Note:
>> patches 137-187 used a "-" instead of a "." causing them to not work when copy/pasting..
>> figured might as well submit the change, and if you guys like it, then keep it
>> if not, then oh-well.. Please have a look through and let me know..(I really appreciate
>> the feedback with the last set I had sent...)
>
> Once you gather all the feedback from the maintainers, could you please
> resend it to trivial@kernel.org in one larger patch rather than split into
> hundreds of one-liners?
>
> Thanks,
>

o.k. jiri I sent out one patch with all of this on it.. just one 
problem, I forgot to add you to the Cc on it..(sorry for that..)so 
hopefully you see it..

Justin P. Mattock
