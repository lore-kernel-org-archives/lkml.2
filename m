Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab0LBEK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 23:10:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918Ab0LBEK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 23:10:58 -0500
Message-ID: <4CF71D75.6070908@redhat.com>
Date: Thu, 02 Dec 2010 12:15:49 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [Patch] debugfs: remove module_exit()
References: <20101109092449.6284.90481.sendpatchset@localhost.localdomain> <20101201013547.GA19390@kroah.com> <4CF5EC28.6060402@redhat.com> <20101201155635.GA29078@suse.de> <4CF70FCE.7060606@redhat.com> <20101202035906.GA10006@suse.de>
In-Reply-To: <20101202035906.GA10006@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/10 11:59, Greg KH wrote:
>>> Even if they were (and hint, I don't think they are), they have nothing
>>> to do with the patch you created so they don't belong here.  The rule is
>>> "one patch per logical change" and you didn't even describe that you
>>> were removing these lines in the changelog entry, so that's two strikes
>>> against removing these lines.
>>>
>>
>> Ok, teach me where DEBUG is used in that file?
>
> It is.  And even if it isn't, it still shouldn't be done in this patch,
> which is my main point here.
>

I see.

>>>> Huh? Wasn't it a module before?
>>>
>>> Yes it was.
>>>
>>>> I think the problem is tracers use debugfs, it needs to depends on DEBUGFS=y.
>>>
>>> So if you disable tracing, then you could use debugfs as a module,
>>> right?  So the patch should not be applied.
>>>
>>
>> No, that CONFIG is a bool, no way to make it as a module.
>> Since you insist, I will send a patch to make it as a module.
>
> {sigh}  No, that's not what I ment at all.
>

Totally confused. :(

If you want to make it as a module, then we should not use 'bool'
and tracers should depend on =y.

If not, then this patch applies.
