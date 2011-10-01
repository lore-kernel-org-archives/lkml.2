Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1JART2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 13:19:28 -0400
Received: from nm4.bullet.mail.sp2.yahoo.com ([98.139.91.74]:26836 "HELO
	nm4.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751486Ab1JARTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 13:19:23 -0400
X-Yahoo-Newman-Id: 210724.88231.bm@smtp214.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: g2FM6P0VM1m718uR4hxw.z4yP7nCb1B.kx9f2Q6GGQNcW6Q
 saI40Ib_I7ogi6lYnU59QsyTIPaMjKruRw4uz4Bee_UbzbJPMqu4W.1w5v20
 LPtaSuxlitgUWqCT7HqPz9SCrTYducUDU0ftcgrQRLs23M6vyT72IQGn5rxi
 .So8Ti2NINP78j1e40Q6VnKf1SQBd8iWNJ8u84jJvaslTPSYBqykmLdrYDh4
 c0mCexY20X6CGvfRhnTgPX9yyvZ7i4SjjN8nchbDbhCKVYQKsiZ804r71JiU
 EYa_bvuf0kseX2aVknrQHR5LYQcWQrvLFwMKwK8xd.AOayuie7QduWa9V17g
 KHoGecdfrqcHEiltchsjN6H4tYY776xWA6I2VXm2oRAJgX2zreJdKOn0vo_1
 gkPwzFSkRXa1Ymakxz5RbHErudGqEFs5.bSDXZ8JIFLeOOMS5UC1J
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Sat, 1 Oct 2011 12:19:16 -0500
From: Andy <akwatts@ymail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001171916.GA11989@zeus>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20111001141751.GA8937@zeus>
 <20111001142848.GA27058@kroah.com>
 <20111001165659.GB18690@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001165659.GB18690@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 06:56:59PM +0200, Willy Tarreau wrote:
> Result: it's correct. With a bit of scripting, it's easy to match
> tags signatures with tarballs'.

I must be doing something wrong. I only have the 2.6 git repo (so my tags
don't drill down to 2.6.x.y just 2.6.x) but my experiement isn't giving
the results I expected.

[Cloned repo]
$ git archive --format=tar --prefix linux-2.6.39/ v2.6.39 | md5sum
482f8bd941def0548a95f34e2d290dfd  -

[Downloaded from kernel.org]
$ bzcat linux-2.6.39.tar.bz2 | md5sum
833d224ee42ddc1e7c2d256368b5d7b3  -

~ Andy
