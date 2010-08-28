Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab0H1TIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 15:08:21 -0400
Received: from n58b.bullet.mail.sp1.yahoo.com ([98.136.45.31]:27984 "HELO
	n58b.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752058Ab0H1TIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 15:08:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 637593.28255.bm@omp201.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=2GZT3KGtoKN0GOK+5rKDNVTnsktQdZ8Jtt17OkGtgMN+Qvzm62TUzM5cEUDyUpXk5w+cX2tJM7rtYL6I35yERQkS4jGMJHGYzv2+3j0qM1ZZ4dGloHxHQA2b5fDnkQ+2DVtud0Mh1rA8x2n9s/MqkIcDxSlbUbgHhBTscf0SxvQ=;
Message-ID: <427545.4213.qm@web180305.mail.gq1.yahoo.com>
X-YMail-OSG: 8brwD1gVM1nIn7rAgqhSjTgsdwq2ZKTT30sKUCui2PImwv5
 _rvKqBrA5sWgrJxrk8Y.dYj2XtdgFvFtjonKB7s7XouHAhIxn09ZOnaivgbN
 7CLdZh1h.2hXbrth4MTTQXD8AELyaevF0ymN1n3nxV7sapkDfeaCHXHMVYLZ
 LEZIh1coqm8PWHap3CIlYBR.YkgrCeSCACXeWNoUsUCmBNw0up2rhqNR_4Vc
 0MSA8kJVp5v6TF1acVOjmycNxlpSx.3MdGr6Bps5usIeKgK_7gdhfl3tUjBO
 7dlqeJbIhzXfdpPq.wiEXhcClRYPeXs3ewLoOwfQPIfM-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 28 Aug 2010 12:08:20 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v3] gpio: Add driver for basic memory-mapped GPIO controllers
To: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20100827155751.GA6514@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Much better, thanks!

But  do it without BUG()... assume that all
uses of BUG() are errors, unless the OS
really has *NO* way to continue operating.
In this case, it can clearly limp along.


- Dave


