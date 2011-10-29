Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1J2T1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 15:27:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47869 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1J2T1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 15:27:12 -0400
Message-ID: <4EAC538D.10606@garzik.org>
Date: Sat, 29 Oct 2011 15:27:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org> <28364.1319915586@turing-police.cc.vt.edu>
In-Reply-To: <28364.1319915586@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2011 03:13 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 26 Oct 2011 16:22:35 EDT, Jeff Garzik said:
>
>>     For this reason, I am tempted to modify my new, GPG-signed pull request
>>     template as follows, for subsequent pull requests:
>>
>> 	---<begin GPG signed text>---
>>
>>     	pull req description
>>
>> 	"Please pull from $branch\n$url $branch"
>>
>> 	"Top of tree is $sha1_commit"
>>
>> 	---<end GPG signed text>---
>>
>> 	diffstat
>> 	diff
>
> Note that this can be problematic as well - there's probably a lot of tools out there
> that will be less than gracious when presented with a GPG-signed text with non-signed
> trailing text.  Maybe GPG-sign from "pull request" to "diffstat" and make the diff an
> attachment? (That would also allow attaching a gzip'ed diff, which would save vger's
> bandwidth :)

I'm not sure I buy that.  A GPG-signed email, something that's been 
around for more than decade, transits the system with unsigned email 
headers.  GPG content is commonly delivered buried inside a larger 
container.

	Jeff



