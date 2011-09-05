Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1IEUBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 16:01:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43447 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab1IEUBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:01:06 -0400
Message-ID: <4E652A36.1070101@zytor.com>
Date: Mon, 05 Sep 2011 12:59:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <2722845.TegCUU4bu0@wuerfel> <CAMe9rOo2JdzerzfTAFER8rZEOGZkp6HxstdT4_3_s0x6UwTPow@mail.gmail.com> <201109051921.59776.arnd@arndb.de> <CAMe9rOpYy5Y27G7anE82+_udYUf6JGA3N=hZdnf_FieLkRXdBA@mail.gmail.com> <CAMe9rOoDjV8UC++X50FtNvgAac23rWu1EEju-3aUE939u8Lv1w@mail.gmail.com>
In-Reply-To: <CAMe9rOoDjV8UC++X50FtNvgAac23rWu1EEju-3aUE939u8Lv1w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2011 12:54 PM, H.J. Lu wrote:
> 
> Since  readv/writev/preadv/pwritev have const struct iovec *iov, I
> have to copy the whole array.  compat_sys seems more efficient.
> 

compat_sys for these do exactly what we want, right?

	-hpa
