Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0JYQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:25:57 -0400
Received: from web37602.mail.mud.yahoo.com ([209.191.87.85]:33118 "HELO
	web37602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757316Ab0JYQZ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:25:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hnmmcT+FDJoGsKes5ju1yBLJugnqZHXAk9cGsMCAqV/61hjwT6qi6CjUyBq8yaYiIFW9j6v/Ym025mhmldBvOcqzlAPXYlevwRc11kq1I8qN0vDWuZ0Jo/KFrAxYNT4FhNc8BQjDzQT6HX0rBZsBpxtTVbpWWh7gDR5gNG9B4E4=;
Message-ID: <221435.47733.qm@web37602.mail.mud.yahoo.com>
X-YMail-OSG: mLQechsVM1kuzq0XSzuWPRm5bWGYK0BTQ0vAl72xWNED6MW
 YKyqlN34R0ILPpfFBFx2nOxPrHMYREDkH_sSklKsoQeQjpi25NRjZuGJyQRs
 JTiTldmqOwz0KqU3sKZfJ7V5_hote.MCunFt2jG7ruVwnqe7KmUY2lh3O9gP
 e9SbcCpx1EbVwf5muICWkbNl6DBeo8cC8DvinlsMHYkQvHVNrkVwJB9pXCD1
 DUJWkKeyk3JQZbqCXNj0JXPtFEFWhbJ_XrFva22acPB0SiTFhovapk1ka5nj
 dQ8Zx7lm4WXx.oHKC6Inol92iGtmN09dTPcaVK8jTpM1SgnuJV.4bWL.FkD6
 zZgDs0P.Hau4-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 09:25:54 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 0/29] My patch queue for memorystick subsystem
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1287972070.5205.12.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to summarize my impression until now:

1. There are 3 functional fixes to Jmicron driver, which are rather small
when taken to their essence (disregarding renames and idle code movements).

2. There is 1 functional enhancement to the MS Pro driver, not too big,
pertaining to extended command execution and resulting in 10% speedup in
some cases.

3. There are 25 patches which just rewrite everything for no good reason
(by this I mean bugs or missing functionality).

Why don't we deal with p.1 and p.2 first, before going to the p.3, as I
suggested from the beginning?

I don't have any specific objections to Ricoh driver as it is.



      
