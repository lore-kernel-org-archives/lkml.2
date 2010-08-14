Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab0HNOJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 10:09:01 -0400
Received: from psw.ro ([94.62.132.84]:36868 "EHLO psw.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab0HNOJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 10:09:00 -0400
DomainKey-Signature: a=rsa-sha1; h=Received:DKIM-Signature:X-Virus-Scanned:Received:Received:Received:MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:Organization:In-Reply-To:References:Message-ID:X-Sender:User-Agent; b=T4O3LaQ686DL5zLSD9atxSRGrOpg4H/WJMsBiEPpvtFWbmgoCmvztj1+mGMJDSEIn3MW3yAuCDgkB3Rj7NnXqCudNas3lfDQNPkCZBU4ihpL5RGu08z35Jbn/iO4Y+CyeRlk8A8y4CdCPwxD49dMl+vaddDfgyciY1s+6RfsICU=; c=nofws; d=psw.ro; q=dns; s=mail
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Sat, 14 Aug 2010 17:08:54 +0300
From: Arthur Titeica <arthur@psw.ro>
To: Greg KH <gregkh@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@kernel.org>, <lwn@lwn.net>
Subject: Re: Linux 2.6.35.2
Organization: PharmEc Software
In-Reply-To: <20100814133942.GA17430@suse.de>
References: <20100813212313.GA22102@kroah.com>
 <a00737cba20cb46512a2248e0477cc0b@linux.psw.ro>
 <AANLkTi=YfKZkE6ee6rE9LvtAiQ6F0YaTHbN+O_dTGHKb@mail.gmail.com>
 <20100814133942.GA17430@suse.de>
Message-ID: <59961099b1fbdb3e827d3c9f9bed3532@linux.psw.ro>
User-Agent: Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Aug 2010 06:39:42 -0700, Greg KH <gregkh@suse.de> wrote:
> On Sat, Aug 14, 2010 at 02:21:31PM +0300, Pekka Enberg wrote:
>> On Sat, Aug 14, 2010 at 1:35 PM, Arthur Titeica <arthur@psw.ro> wrote:
>> > On Fri, 13 Aug 2010 14:23:13 -0700, Greg KH <gregkh@suse.de> wrote:
>> >> I'm announcing the release of the 2.6.35.2 kernel.
>> >>
>> >> All users of the 2.6.35 kernel series must upgrade.
>> >>
>> >
>> > I'm not sure this is the right mailing list but this is the first
>> > kernel that fails to boot for me (since 2.6.33.x).
>> >
>> > The laptop just restarts right after "Freeing unused kernel memory:
>> > 628k freed"
>> >
>> > 2.6.35.1 is fine with the same .config.
>> >
>> > Anyone willing to help me to debug?
>>
>> You could try 'git bisect' between v2.6.35.1 and v2.6.35.2 to narrow
>> the problem down to a specific commit.
> 
> Yes, if you could please do that, it would be most appreciated.
> 
I'm trying but I'm not even close to a dev and anything beyond 'git
pull' looks tricky.

I've gotten so far:

$ git bisect start
$ git bisect bad
$ git bisect good v2.6.35.1
fatal: Needed a single revision
Bad rev input: v2.6.35.1
$ git bisect good v2.6.35
Bisecting: 3941 revisions left to test after this (roughly 12 steps)
[2192482ee5ce5d5d4a6cec0c351b2d3a744606eb] Merge branch 'for-rmk' of
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into
devel-stable

What next? ;)


-- 
Arthur Titeica

