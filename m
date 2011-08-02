Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839Ab1HBEKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 00:10:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64952 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab1HBEKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 00:10:31 -0400
Message-ID: <4E3778AD.8020306@landley.net>
Date: Mon, 01 Aug 2011 23:10:21 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Here's a unified kernel git repo covering 0.0.1 to the present.
References: <4E2A43F5.1020209@landley.net> <20110802011851.GC16305@fieldses.org>
In-Reply-To: <20110802011851.GC16305@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 08:18 PM, J. Bruce Fields wrote:
> On Fri, Jul 22, 2011 at 10:45:57PM -0500, Rob Landley wrote:
>> Ever done a "git annotate" that stops at 2.6.12-rc2, and wanted to see 
>> the full history?  Here's an repository that goes all the way back to
>> 0.0.1 (through bitkeeper and all those old tarballs), which otherwise
>> works as normal (git pull updates it from Linus's tree, you can commit
>> to it and branch from it, etc)
>>
>> Here's the tarball:
>>
>>   http://www.kernel.org/pub/linux/kernel/people/landley/linux-fullhist.tar.bz2
>>
>> To install it:
>>
>>   1) Download, extract, cd into the directory.
>>   2) git checkout -f
>>   3) git pull
> 
> Note if you use git-replace instead of grafts then you should be able to
> post it as a normal clone-able git tree.
> 
> --b.

*shrug*  It worked for me?  I posted a link to the script it came from,
you could ping that guy or tweak his script to do what you want.

My general response to git trees is to convert them to mercurial because
git's UI is utterly horrible, and its infrastructure overcomplicated.
That said, it's what the kernel uses, so it's ubiquitous.

I got pointed at another full history git repo earlier today, maybe
it'll work better for you?  Haven't tried it myself, I'm pretty happy
with the one I posted.

  https://twitter.com/mirell/status/98086867580354560

Rob
