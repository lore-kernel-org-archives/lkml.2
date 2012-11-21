Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2KUJlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:41:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45267 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2KUJlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:41:00 -0500
Message-ID: <50ACA1A8.1030307@suse.cz>
Date: Wed, 21 Nov 2012 10:40:56 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arend van Spriel <arend@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Streamlining Developer's Certificate of Origin, Signed-off-by
 tag
References: <CAB=NE6WTFv80w6bkQNqaAG69CADmdiqa-tLKD9s=h_p+1D92tQ@mail.gmail.com> <20121120211634.11513416@pyramind.ukuu.org.uk> <50ABFF4E.2050101@broadcom.com> <CAB=NE6UnA2o7ur+0WGouJR984LqtdTYey41XzQCvAw1djhkOkA@mail.gmail.com> <20121121001043.7e1a68df@pyramind.ukuu.org.uk> <CAB=NE6X9z5YEPD5avSkYd6Ayc90kHF4+b1Vjfw8cvZ3A0gwXOQ@mail.gmail.com>
In-Reply-To: <CAB=NE6X9z5YEPD5avSkYd6Ayc90kHF4+b1Vjfw8cvZ3A0gwXOQ@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 02:13 AM, Luis R. Rodriguez wrote:
> Ah so keep the original in place to let references to the original in
> whatever way those may exist to keep pointing but promote new usage to
> a copy and.. perhaps refer to the new copy in master, or just leave
> that in place as is?

It depends if they really want to have the same thing we do. I.e. don't
they want to rephrase the document a bit? If so, there is no point of
linking the document at all.

If no, we can create a separate document from that in the kernel so that
we allow people to link that at some fixed version using git commit SHA.
This can be done easily doing a link to git.kernel.org.

The link to git.kernel.org might seem to be long. One can create a
dynamic helper on some web like signed-off-by.cgi?id=SHA and it will
return that document in that version. (It will redirect basically.)

regards,
-- 
js
suse labs
