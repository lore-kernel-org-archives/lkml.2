Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab0K3FGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 00:06:19 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62909 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0K3FGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 00:06:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=MRdAQvQYvnnHAFKRcafNU5kRWRDvGvNqqqyG/O5ULCHhDnCUzCQs9nBLg1gTt2ZwzU
         BeWvPWRZJaq/1cAp5olOgCYd9CJ9EOM7+leRrks1Fm7GwfUP1cRR/nJL7R1ecZr1M3uz
         JF/4uxBaeWUmMMJAI00oeHlNw0JLmgVXL23Gg=
MIME-Version: 1.0
In-Reply-To: <20101129140721.40bbc1e8@lxorguk.ukuu.org.uk>
References: <1290941875.13526.15.camel@cai.gentoo> <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
 <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
 <20101129020610.7ea7c79e.lisa@ltmnet.com> <1290961207.13526.31.camel@cai.gentoo>
 <20101128234634.461daec4@pyx> <1290994083.877.13.camel@cai.gentoo> <20101129140721.40bbc1e8@lxorguk.ukuu.org.uk>
From: microcai <microcai@fedoraproject.org>
Date: Tue, 30 Nov 2010 13:05:51 +0800
X-Google-Sender-Auth: 7iDMzU9uC8ctMnvF8v2yBWQl3nY
Message-ID: <AANLkTi=qRvSC3hDm032tL0bgWV93ON6A+SEBn+1qmWZ8@mail.gmail.com>
Subject: Re: VT console need rewrite
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lisa Milne <lisa@ltmnet.com>, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, let me vanish in a few months.

hopefully I'll be back with a patch fix that stupid 512 glyph limitation.
