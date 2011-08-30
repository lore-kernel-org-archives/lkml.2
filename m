Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1H3EqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:46:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47161 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab1H3EqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:46:14 -0400
Message-ID: <4E5C6ADA.3030409@zytor.com>
Date: Mon, 29 Aug 2011 21:45:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com> <4E582EAA.1040108@zytor.com> <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com> <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com> <4E584492.5090406@zytor.com> <CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com> <CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com> <CA+55aFzuY+U0nf58-9P5CFaYAPKMQ3fQMGGUUkjbxRRCK7=A3Q@mail.gmail.com> <CAGZ=bqKjnsEKz_CxcW+wRoCL_CY-kipedf2wB=BVUWRB0427tw@mail.gmail.com>
In-Reply-To: <CAGZ=bqKjnsEKz_CxcW+wRoCL_CY-kipedf2wB=BVUWRB0427tw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2011 07:16 PM, Kyle Moffett wrote:
> 
> The goal of x32 as I understand it is to allow 32-bit x86 programs to
> use all the nifty extra registers and faster instructions (IE: syscall)
> without needing to deal with the 2x memory overhead of 64-bit
> pointers.
> 

That is the major goal.  A minor goal is to bring x86-64 goodness to
those who have an (irrational) fear of 64 bits thinking it is a major
porting effort.  Thus, *source-level* porting effort matters, but it is
completely subordinate to the major goal.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

