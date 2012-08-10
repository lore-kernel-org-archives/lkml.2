Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442Ab2HJWjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:39:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55637 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760351Ab2HJWjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:39:07 -0400
Message-ID: <50258D88.7090903@zankel.net>
Date: Fri, 10 Aug 2012 15:39:04 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Max Filippov <jcmvbkbc@gmail.com>, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-next@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Marc Gauthier <marc@tensilica.com>,
        Kirill Krinkin <kirill.krinkin@gmail.com>
Subject: Re: xtensa port maintenance
References: <50205592.1030205@gmail.com> <201208102115.59946.arnd@arndb.de>
In-Reply-To: <201208102115.59946.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Given the recent renewed push for Xtensa, I'll step in to feed the 
changes upstream. We might change that in future, though.

Max has volunteered to help bring the Xtensa port up-to-date. Most of 
the recent development was done on outdated trees and never got 
submitted in true kernel-manner (i.e. small changes at a time). It's 
also important to bring the ecosystem (compilers, libraries, etc.) to 
the latest trees, and my understanding is that there's also work going 
on in that area.

I have set up a tree on github for now, and will work close with Max to 
get his changes to Stephen's linux-next tree and eventually Linus' tree. 
I think it's fine to add Max as a second maintainer, so he can help 
filtering patches.

Cheers!
-Chris

On 8/10/12 2:15 PM, Arnd Bergmann wrote:
> On Monday 06 August 2012, Max Filippov wrote:
>> I have a couple of questions regarding the path of xtensa-specific patches
>> upstream:
>>      - which git tree should they be targeted for? Should I set up a tree for
>>        pull requests, or will patches be picked up into some existing tree?
>>        (Looks like Linus' tree is the right target. AFAIK previously xtensa
>>        patches went mostly through akpm tree).
> Setting up a git tree is a good first step if you want to be the official
> maintainer, and if you want to get it included into linux-next.
>

