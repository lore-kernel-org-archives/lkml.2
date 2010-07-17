Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab0GQX5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 19:57:32 -0400
Received: from n4.bullet.mail.gq1.yahoo.com ([67.195.9.84]:40299 "HELO
	n4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756096Ab0GQX5b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 19:57:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 708825.85747.bm@omp204.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=01LLD6c8zwcEUsZrTZ89NR/S4c0mLJ7As9nFGuKeWl608LGwO8J0Z9txSX03mtbZG/+E5GRsIVKlVSx4YClL9gaoVXkQ1FY66BR+SSkOL+MtY7f7CZOfw9tRqEVjm8D6DdKtiK/xU9dxg1BPFPSlZT5HOKtt8bE1erezJq3rBZQ=;
Message-ID: <536935.13464.qm@web180310.mail.gq1.yahoo.com>
X-YMail-OSG: dujITN8VM1nT5fPngo1F5ABtNIvwplxCa4yGvhElufSsqog
 P5XXZ2tK.5IqBFBVw04phQYzfOGFPPemdA5S2WTCVAXg_5n1Bq4q7L0k_P0C
 p0.S2bybyQNJxiMjleVNGsetkZoC0w2Empsv5eUGvVCUYgyy6_HlRXdj3dl4
 k5jvFys6CUHYbUQzadnu2ZkRHVyFmRtfH4.IKS2QNGrIVI.jA97Ow5TZBNeN
 S6oUE6xZDaDAqbCrtNHjhuMRS9hsv1hvEUqNWdnpVWDAAikqhRx8FT_9pJLn
 qEPyzQxYZwPJRjJbe6g--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.276605
Date: Sat, 17 Jul 2010 16:57:30 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
To: Greg KH <greg@kroah.com>,
        =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
In-Reply-To: <AANLkTinOgKYlzB98LdurvLAV_-AYO_1SJPDneJt_iL5E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > David, any thoughts on these versions

Still no fan, since it just duplicates
existing functionality from the composite
framework.  Using  the existing mechanism
seems preferable to me:  you want a serial
number? provide one using the existing scheme
and just make sure it follows the rules.



