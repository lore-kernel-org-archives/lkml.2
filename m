Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1JZEyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 00:54:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38927 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1JZEyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 00:54:53 -0400
MIME-Version: 1.0
In-Reply-To: <20111026043419.GA30368@gamma.logic.tuwien.ac.at>
References: <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	<1319004836.31823.57.camel@wwguy-huron>
	<20111020045927.GB23044@gamma.logic.tuwien.ac.at>
	<1319119852.2111.2.camel@wwguy-ubuntu>
	<20111021012442.GB26758@gamma.logic.tuwien.ac.at>
	<alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com>
	<20111026025014.GB24956@gamma.logic.tuwien.ac.at>
	<1319601333.14693.19.camel@wwguy-ubuntu>
	<20111026040332.GF24956@gamma.logic.tuwien.ac.at>
	<1319601654.14693.20.camel@wwguy-ubuntu>
	<20111026043419.GA30368@gamma.logic.tuwien.ac.at>
Date: Wed, 26 Oct 2011 00:54:52 -0400
X-Google-Sender-Auth: Rs29ezFfyhekZ3AwE3Of5D3qDZw
Message-ID: <CABDyM6T-_UWjQtb9E8Yie1kj5UpDHZNRTb13xJBt=YFczbwxZA@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Richard Yao <ryao@cs.stonybrook.edu>
To: Norbert Preining <preining@logic.at>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Norbert,

Try doing "iwconfig wlan0 rts 0". As I said less than an hour ago in
my rather lengthy post to the Linux mailing list, that made things
better for me, but not perfect.

Speaking of which, that post described my findings on why I was having
wireless issues that I did not post several weeks ago because I didn't
think anyone would care. Since people do seem to care, I probably
should have CCed that email to everyone else that was on people's CC
lists, but I am new to mailing lists (and to Linux), so I did not
think of it until now.

Yours truly,
Richard Yao

On Wed, Oct 26, 2011 at 12:34 AM, Norbert Preining <preining@logic.at> wrote:
> On Di, 25 Okt 2011, wwguy wrote:
>> > But *I* cannot be sure about it ;-)
>> >
>> Are you seeing this without suspend/resume?
>
> Yes. I just shut down and started, and the same happens again. If you
> need the dmesg output let me know.
>
> Best wishes
>
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> RUNCORN (n.)
> A peeble (q.v.) which is larger that a belper (q.v.)
>                        --- Douglas Adams, The Meaning of Liff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
