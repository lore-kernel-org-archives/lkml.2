Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab2CLPEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:04:35 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:12473 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab2CLPEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:04:32 -0400
Message-ID: <4F5E107F.1050400@tilera.com>
Date: Mon, 12 Mar 2012 11:04:31 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: <torvalds@linux-foundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>
Subject: Re: [PATCH] tile: remove a non-existing header
References: <1331561930-14964-1-git-send-email-mchehab@redhat.com> <4F5E08C7.9070400@tilera.com> <4F5E0F78.3000308@redhat.com>
In-Reply-To: <4F5E0F78.3000308@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2012 11:00 AM, Mauro Carvalho Chehab wrote:
> Em 12-03-2012 11:31, Chris Metcalf escreveu:
>> On 3/12/2012 10:18 AM, Mauro Carvalho Chehab wrote:
>>> While testing some API changes at the EDAC core, I've tested the EDAC
>>> drivers compilation on all supported architectures, including Tilera.
>>>
>>> I noticed that Tilera upstream code has issues: it doesn't compile with
>>> kernel 3.2:
>>>
>>> [...]
>> Thank you, but nack.  The header is provided in the latest gcc tip code. 
> Hmm... the gcc cross-compiler I've downloaded from Tilera site about one month
> ago didn't have it (tilegx-unknown-linux-gnu-gcc (GCC) 4.4.6).

Yes, I need to update it.  We've been focusing on the community return and
haven't updated our own web site recently :-)

>> Sorry for the API thrash!  It's certainly OK to comment it out for the time
>> being; it just provides some assembly macros for specifying feedback-guided
>> optimization.
> It would be a good idea then to add some Makefile magic to check it,
> maybe creating an empty linkage.h if the header is not found at the gcc
> toolchain, in order to support all gcc variants that support tile arch.

True, although, since there hasn't been an official release of gcc that
supports tile yet (the first will be 4.7), I'm less worried about
compatibility issues.  The gcc we ship to our customers has supported it
since day one, and 4.7 and following will support it, so it's just the
Tilera web site version, and I think it's OK for me to just update that one.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

