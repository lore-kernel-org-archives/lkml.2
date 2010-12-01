Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0LARzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:55:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63731 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab0LARzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=QuMduIgVwtIU1mtw/HoxofH++2tlfJvKRGLazYE2zyB/D2kZle7o6WzBmw7sdz2TF2
         cpg3u1QBVrXQDleOsX4gPiGy3On0DZqz+bWAC+Q6WWi9wO6WGQ/7eIi4wdTQo8UVY1yY
         QCxJykLGNaUc3inZiKfg43MUnxNe1xu45diOE=
Date: Wed, 1 Dec 2010 15:55:04 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: eranian@gmail.com
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        robert.richter@amd.com
Subject: Re: [PATCH] perf: add csv-style output to perf stat
Message-ID: <20101201175504.GA13584@ghostprotocols.net>
References: <4cf67197.41e9d80a.7d37.08aa@mx.google.com>
 <20101201170647.GC24641@ghostprotocols.net>
 <AANLkTi=C0FX2f-SS65p9nXWB8ogNqtgJVa8e+N6C32+5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=C0FX2f-SS65p9nXWB8ogNqtgJVa8e+N6C32+5@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 01, 2010 at 06:24:46PM +0100, stephane eranian escreveu:
> On Wed, Dec 1, 2010 at 6:06 PM, Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > Spaces are being added, gack, will fix. Tried to use the same option letter and
> > long option name as in 'sort':
> >
> >       -t, --field-separator=SEP
> >              use SEP instead of non-blank to blank transition
> >
> > But then 'perf stat' already uses -t for --tid, so in 'stat' we would have to
> > use '-x'/--field-separator.
> >
> Fine with me.
> I can re-spin the patch to add the flexibility to name your SEP.

please
 
> > Argh, I think we should stop using short options, only assigning something when
> > it gets from seldomly used to just before making it the default 8-)
> 
> I tend to use the short options....

If you're ok with keeping --field-separator as the long option to match
what is in 'perf report', deal :-)

- Arnaldo
