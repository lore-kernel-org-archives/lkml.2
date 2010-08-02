Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0HBQKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:10:14 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36133 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533Ab0HBQKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:10:12 -0400
X-Sasl-enc: umkJy9eSUYFumNHjNAmFouTjGUNyHSBcteU1IsDx6bT3 1280765404
Date: Mon, 2 Aug 2010 13:10:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
        linux <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Karsten Schaefer <karsten.schaefer@uni-konstanz.de>
Subject: Re: ext4 performance regression 2.6.27-stable versus 2.6.32 and
 later
Message-ID: <20100802161001.GF32757@khazad-dum.debian.net>
References: <4C508A54.7070002@uni-konstanz.de>
 <AANLkTimh3eKc-M4xphq0djnSa=4W4hUf7KRf=icdF9Rk@mail.gmail.com>
 <4C56A240.1040506@uni-konstanz.de>
 <20100802160405.GE32757@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802160405.GE32757@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010, Henrique de Moraes Holschuh wrote:
> On Mon, 02 Aug 2010, Kay Diederichs wrote:
> > Performance-wise, we tried mounting with barrier versus nobarrier (or
> > barrier=1 versus barrier=0) and re-did the 2.6.32+ benchmarks. It turned
> > out that the benchmark difference with and without barrier is less than
> > the variation between runs (which is much higher with 2.6.32+ than with
> > 2.6.27-stable), so the influence seems to be minor.
> 
> Did you check interactions with the IO scheduler?

Never mind, I reread your first message, and you did.  I apologise for the
noise.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
