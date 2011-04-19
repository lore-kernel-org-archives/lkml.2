Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1DSKVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:21:41 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35613 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1DSKVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=n0w+LOtL2tOOwYWlGQYKPEZbUJLWAlBnGIDpYR2gNUWI29Ofd+Zg2qA3JKaWT0y1Tc
         +NrRAr0cBoq+ycFrhIx/2a3CvoD1fuKDeP3SVapdG/NHdrm2ix2Bxwit+VKH1U2Cyk6+
         Wdn5JOepxLDMXcvbYJ4luFXMyb7ZYxHMBfRVY=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1303207320.2779.9.camel@localhost>
References: <1301874939-2630-1-git-send-email-sedat.dilek@gmail.com>
	<1301900656.2760.6.camel@localhost>
	<BANLkTi=WTWa4yj+ysta8jiHs9r4MX5Gf_g@mail.gmail.com>
	<1301911604.2760.52.camel@localhost>
	<BANLkTi=DHTjL7M9bzYY-t5MJS2s1WScBCQ@mail.gmail.com>
	<BANLkTinysw90tiWhFRmQH_0LWx7o+sD1-A@mail.gmail.com>
	<1303207320.2779.9.camel@localhost>
Date: Tue, 19 Apr 2011 12:21:36 +0200
Message-ID: <BANLkTinyp9Ne_OBPf+ejERjAPeUUxga2cQ@mail.gmail.com>
Subject: Re: [PATCH] ubifs: Use empty_iops and empty_fops consistently
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 12:02 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Tue, 2011-04-19 at 11:50 +0200, Sedat Dilek wrote:
>> can you take this patch into your UBIFS tree?
>> Thanks in advance.
>
> Sorry, forgot about this patch. Pushed to ubifs-2.6.git tree, but I
> re-wrote the commit message because I found yours a bit confusing. Is
> this OK?
>

Thanks.
Nice wording, fire it up :-).

> http://git.infradead.org/ubifs-2.6.git/commit/8c355ad269c9da635fad8367e9a6d52bf3fe08c8
>
> --
> Best Regards,
> Artem Bityutskiy (Артём Битюцкий)
>
>
