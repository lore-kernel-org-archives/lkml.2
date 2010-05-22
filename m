Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0EVKeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 06:34:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46467 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab0EVKem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 06:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DYsLA8QQ3DhZ7Wmf1U5yMdkOZwnLYW3l5BxbLYGyw3qx7WOzUgaD/dR1pGveLZafbk
         UwEoxfV4/aP049bic7n95pneK2iOLDsJ2nhRpPCc/Ftf+hqvb1sSCfzrjkxHBvdufoUt
         3nMKJPg9sYuRRqCaVTdM8KFby06WSkJTxrPVs=
MIME-Version: 1.0
In-Reply-To: <20100522103102.GA11788@gondor.apana.org.au>
References: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
	 <HqroMXsT-CJ.A.qYG.f_y5LB@chimera>
	 <AANLkTikXPfDVhwsUMr5yDpsvgk06QrMFXpG22k8T0ydi@mail.gmail.com>
	 <20100522103102.GA11788@gondor.apana.org.au>
Date: Sat, 22 May 2010 13:34:40 +0300
X-Google-Sender-Auth: jf8leNoUVDna9lYLQTRM5QfYtFw
Message-ID: <AANLkTil0K6LRPdSCZP2PQJGpfmKeAbsMeH-UCo1Msy2Y@mail.gmail.com>
Subject: Re: [Bug #15601] [BUG] SLOB breaks Crypto
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "michael-dev@fami-braun.de"@ogre.sisk.pl,
       David Miller <davem@davemloft.net>, Matt Mackall <mpm@selenic.com>,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 1:31 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sat, May 22, 2010 at 01:22:57PM +0300, Pekka Enberg wrote:
>> On Mon, May 10, 2010 at 12:17 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a summary report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
>> > know (either way).
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15601
>> > Subject         : [BUG] SLOB breaks Crypto
>> > Submitter       : michael-dev@fami-braun.de
>> > Date            : 2010-03-15 13:39 (56 days old)
>> > Message-ID      : <4B9E38AF.70309@fami-braun.de>
>> > References      : http://marc.info/?l=linux-kernel&m=126866044724539&w=2
>>
>> Herbert, David, Matt, this bug should be fixed by the following two
>> commits, right?
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=18eb8ea6ee4cc9ed39b45f95b734f523bcfb586b
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=273fca0ecad9305247043815e185d1bfd04047d4
>
> Yes.

Thanks Herbert! Lets CC stable in case they want to pull the commits
for 2.6.34.x.
