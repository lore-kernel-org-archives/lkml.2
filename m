Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab1AWINO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 03:13:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41980 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1AWINO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 03:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ly0jonkkDmJ08xerlehYtrX9CufsVuEBuW3kGpMw9ulUrxPKlMCzqgMYxLfMv2Fxh9
         6yGrZhipZvPRLThU8bC+oU0b0H6oKxWdPX9oaz0b7C4KeuSeLdXV7fjw3T0HvDhTA76Y
         EQc248ULclVu/SFAgO++zm4zO3Q9tvEGrsQcQ=
Message-ID: <4D3BE314.3090500@gmail.com>
Date: Sun, 23 Jan 2011 10:13:08 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Icedove/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc1
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com> <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com>
In-Reply-To: <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-19 04:07, Linus Torvalds wrote:
> On Tue, Jan 18, 2011 at 3:54 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> It's been two weeks, and the merge window for 2.6.38 is thus closed.
> 
> Oh, and it looks like mirroring from master.kernel.org is being very
> slow

I think that pulling from kernel.org became slower too. (not sure
exactly when but probably since about a year).

When I run git pull, it just sits there for a long time, with no visible
network/disk I/O, and only after that it starts the "remote: Counting
objects" phase.
I just tried to measure that time and it is ~12s now, which is not that
bad, but I remember that I even had to wait minutes to see the "Counting
objects" phase in December.

Is it because git on the server side needs to figure out which objects I
already have and which I don't? But I thought thats part of the
"Counting objects" phase, so what happens before that, and why are there
no progress messages about it?

Best regards,
--Edwin
