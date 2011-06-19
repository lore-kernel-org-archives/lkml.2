Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1FSOmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 10:42:05 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:2678 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab1FSOmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 10:42:01 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host p5JEfmCi028753
Subject: Re: Does Linux select() violate POSIX?
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Nemo Publius <nemo@self-evident.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=bvmtkv-o3PROYjmOwkBNCBFGv7w@mail.gmail.com>
References: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
	 <1308418985.3539.58.camel@edumazet-laptop>
	 <BANLkTi=Vis=aZ5vn7E0A2LGVPOcmjd+r-g@mail.gmail.com>
	 <20110618193340.53811cbe@lxorguk.ukuu.org.uk>
	 <BANLkTi=bvmtkv-o3PROYjmOwkBNCBFGv7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 16:41:48 +0200
Message-ID: <1308494508.13047.4.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-DCC-debian-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sam, 2011-06-18 at 11:51 -0700, Nemo Publius wrote:
[...] 
> With any "test something, then assume result of test" sequence,
> obviously I can have race conditions with multiple processes or
> threads.  I mean, had I asked, "I call write() and then lseek() to

ACK.

> where I started and then read() on a file; am I guaranteed to read
> back what I wrote?"  And you said no, because some other process could
> write in the meantime...  I would say that is technically true but not
> at all what I was asking.

Then you should reformulate your question because the answer is
technically correct.
If the (technically correct!) answer does not help you, you asked the
wrong question.
It's as simple as that.

Kind regards,
Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

