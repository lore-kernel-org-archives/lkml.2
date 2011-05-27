Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1E0VMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:12:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65041 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab1E0VM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oTpQ+2GIqiRuAUo6PKTSUuF9AHVgy8jMIqddiQf+N4jiidsqWgJjYXVf7+8pAOU3Ec
         4hBswPJPgZ66/LKxX/98SQzFCnoP7Kdjulnnjl2Vj/9Jk5fy45paf3H0imIwqKC5dBI3
         U7CN86U+0BVqVjRkwZAvC73Ati5kpoTZFp4Fg=
Message-ID: <4DE013B6.9070801@gmail.com>
Date: Fri, 27 May 2011 23:12:22 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0a2) Gecko/20110420 Thunderbird/3.3a4pre
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, npiggin@kernel.dk,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: OOPS in configfs when doing d_delete
References: <4D623C62.8030509@suse.cz> <20110221104359.GA18538@noexit> <4D6242AD.2090600@suse.cz> <20110222091415.GD30966@noexit> <4DCBA9A5.9040306@gmail.com> <20110518195842.GB5898@noexit.corp.google.com>
In-Reply-To: <20110518195842.GB5898@noexit.corp.google.com>
X-Enigmail-Version: 1.2a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2011 09:58 PM, Joel Becker wrote:
> On Thu, May 12, 2011 at 11:34:29AM +0200, Jiri Slaby wrote:
>> On 02/22/2011 10:14 AM, Joel Becker wrote:
>>> On Mon, Feb 21, 2011 at 11:47:09AM +0100, Jiri Slaby wrote:
>>>>> 	I think you're right about the superfluous test, but I need more
>>>>> investigation to see what's going on.  Thanks for the report.
>>>>> 	What was causing attach_group() to fail?  Do you know?
>>>>
>>>> Dunno, I just modprobe'd the configfs example from Doc dir
>>>> (configfs_example_macros).
>>>
>>> 	I'm going to revisit the failed example (which shouldn't fail, I
>>> would think).  Can you try the following patch to safely handle the
>>> failure rather than crashing the kernel?
>>>
>>> Joel
>>
>> Hi, what's the status of this? (It's verified to work some time ago.)
> 
> 	The runtime fix is queued up for mainline.  I'll be looking at
> the example code fix for the next merge window.

The fixes for the examples were merged today after being some time in
the -mm tree.

thanks,
-- 
js
