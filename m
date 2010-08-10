Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0HJGyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 02:54:49 -0400
Received: from n3-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.157]:33235 "HELO
	n3-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752398Ab0HJGyo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 02:54:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 967319.58148.bm@omp119.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2XgEszmqOYezxItgpLRldYij2jetNQLDQ9PFplV2mud0xyW2hm0e7pX3LnOM21k6ejHl62muzVFchluA56hhZIP9lD4IW9HJbR0J406q4CBJVkeb0HVb3hcpyPegpqHRsQMKyRcfRt7lu4GIJ5G/nL3+DgXTZ/QHX23izeQ91fU=;
Message-ID: <870112.26677.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: m1X2BiUVM1lHRaBx_a1Mwz55B07Q0es0hEFk80fHFNuc3jZ
 6wUW.oSvJNfn.AcVmJLmii19GdCvHcuJv5XAdp5D0DtjshHJZ0sAT_kjkglU
 ODEQki8gK4WF.SaKCY8OgKjLE3zyjcz9eJNFc1J8XeoB4Xzelu3prrVq1s9Q
 QQDY9LYknWv9rAQCEoHfH._sTxQNOHdR0njWPJzHeRsntIsyUAXmV8P6IZm7
 nHViZGmjjBtB9_JcOqN4Lg4MKr7qdSltMER4a7.ZNZ_oNC_mEKzhdbm4yKty
 wPrulQCzCfs_xsG6uMPLX.d2o8OixkvECnMjzzw--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Mon, 9 Aug 2010 23:54:43 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] spi: omap2_mcspi: make use of dev_vdbg()
To: ext Grant Likely <grant.likely@secretlab.ca>, felipe.balbi@nokia.com
Cc: "Balbi Felipe \(Nokia-MS/Helsinki\)" <felipe.balbi@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "Tereshonkov Roman \(Nokia-MS/Helsinki\)" 
	<roman.tereshonkov@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100810054530.GD3853@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >I know, the sourceforge list is a bit of a pain.

As all sourceforge lists are.

 
> I don't even know
> >who the admin of that list is.

One of the Russian MontaVista crew created
that list, and presumably maintains it.



