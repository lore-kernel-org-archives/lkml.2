Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0HGHea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 03:34:30 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:40795 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0HGHe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:34:26 -0400
X-ASG-Debug-ID: 1281166463-4b8d00010000-xx1T2L
X-Barracuda-URL: http://10.101.1.180:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C5D0C79.5010103@fusionio.com>
Date: Sat, 7 Aug 2010 09:34:17 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-ASG-Orig-Subj: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
Subject: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
References: <4C5BE640.2050801@fusionio.com> <AANLkTindzwVR93MN=6HpevQZh5EqfvnmbzEj9OeG-PLJ@mail.gmail.com> <AANLkTi=WyWdERdyM+X5VOTX02_O_5GqV9hBQ145RmMWg@mail.gmail.com>
In-Reply-To: <AANLkTi=WyWdERdyM+X5VOTX02_O_5GqV9hBQ145RmMWg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1281166465
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 05:51 PM, Linus Torvalds wrote:
> On Fri, Aug 6, 2010 at 8:44 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>                                                                    ... And
>> once you _do_ ask me to merge from you, I still don't want you to do
>> the merge, because I want to know about what conflicts. That's where
>> the bugs almost always are.
> 
> Actually, let me rephrase that.
> 
> Almost all bugs are just individual commits. But the "oh, we had
> conflicts between trees" is where the subtle bugs that are due to
> interactions between two different development projects tend to be..
> 
> So "almost always" is not really true - almost always bugs are just
> simply bugs: incorrect code. I wish we didn't have that, but hey,
> reality clearly hates me.  But the reason I want to see the merge
> problems (even if I then occasionally end up having to send it back
> and say "ok, I see the merge problem and I can't handle it, you do it
> for me") is because that way I _see_ when people step on each others
> feet. Because when it happens, it's ripe for nasty issues, including
> simply ones that are due to bad development habits, or due to bad
> source tree organization.

OK, so a question on this. Say a bug surfaces in the middle of the
release and we push in a change to fix that at 2.6.36-rc3 time. This
same patch will not apply directly to the branch holding 2.6.37 patches
due to code reshuffling or whatnot. How do you want that handled? I
can't pull in your branch and resolve it. The merge conflict may not be
visible to you until 2.6.36 is released and I want to offload the
patches to you, but it will be visible in linux-next pretty much
immediately.

This puts a lot of extra work on Stephen.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
