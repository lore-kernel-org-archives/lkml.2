Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1ICR3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 13:29:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53362 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1ICR33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 13:29:29 -0400
Message-ID: <4E6263B6.9020703@zytor.com>
Date: Sat, 03 Sep 2011 10:28:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110817 Fedora/3.1.12-1.fc14 Thunderbird/3.1.12
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Valdis.Kletnieks@vt.edu, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com>	<CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com>	<4E61BB42.4090301@zytor.com>	<8179020.mG8hWW8BRr@wuerfel>	<14427.1315058668@turing-police.cc.vt.edu>	<9b6a2b8e-365f-4155-85ca-5f72b46a7f3e@email.android.com>	<19229.1315070217@turing-police.cc.vt.edu> <CAMe9rOpdQ=N9pLX13mqigPdDPr0CkEW5+841u4bASicJ4i=b5Q@mail.gmail.com>
In-Reply-To: <CAMe9rOpdQ=N9pLX13mqigPdDPr0CkEW5+841u4bASicJ4i=b5Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2011 10:22 AM, H.J. Lu wrote:
>
> We can't use 64bit ioctl for x32 if indirect pointers are ever passed
> to ioctl.
>

Which they are, in a fairly large number of ioctls.

	-hpa
