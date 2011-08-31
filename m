Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1HaTTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:19:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56221 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab1HaTTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:19:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
Date: Wed, 31 Aug 2011 21:18:37 +0200
Message-ID: <1397886.AAh13B9r2H@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CA+55aFwVJ71=cLsUqMaJ-eGP0doPGBhrse9r++hkbiNYNx5Zjg@mail.gmail.com>
References: <4E582577.2060805@zytor.com> <201108311839.52863.arnd@arndb.de> <CA+55aFwVJ71=cLsUqMaJ-eGP0doPGBhrse9r++hkbiNYNx5Zjg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Gl64Tt/UR68EubS9PgPj6cNJ9bxFm7O4Yh8KjEzxDKu
 AXYLSSxxfI8F+eIlzZ+GBaTUik7cLcj9sevZd/szr/dUr7+GSk
 vEUCOdsXTTriXe3z2TDoIISMcJXI9j8P0iGxe8o96KrvUZPRcn
 pgIJDhwp7BthRVvqGpkSOGaULTxBf1qzcy/jCyqmBoDZdTGaro
 +uU4skIdlCM4YDxcRv30l6zTYTWzdvOX79NVc01CcfMMo3MrBy
 LqLNMGr226zhKi2nlOzmD4P30qwTnPJtmb/5XnUpDdt/WTB5TF
 1yQVO1ST9HczA3/VFdmMv9DjC6Nyb+JzoUY4aCnwz6gnXG6eRk
 oDC0t19KEpQYbOKBvRHs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 August 2011 09:48:35 Linus Torvalds wrote:
> On Wed, Aug 31, 2011 at 9:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > Well, we could chicken out and just use unsigned int for time_t on new
> > 32 bit ABIs, which would buy us time until ~2106 before we need to
> > convert everything to 64 bit...
> 
> You do realize that there are probably quite a lot of programs that
> depend on signed time_t because they really do care about dates before
> 1970?

Yes, it already occurred to me after I had written the above that we
really want it to be signed, especially to allow a meaningful conversion
at least one-way between 32 and 64 bit time_t values.

	Arnd
