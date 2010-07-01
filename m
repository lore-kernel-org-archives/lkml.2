Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0GAKJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 06:09:51 -0400
Received: from n2-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.155]:36563 "HELO
	n2-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752548Ab0GAKJt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 06:09:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 750527.55818.bm@omp127.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=a7gfcc9gIgwmfItGnniX8wb4IrO3XtETq20WzkqQfdPuStNrOH6oNwRn9sacneSg7KLwVEzwZnEfTKoIlFXPGSrhNZHwdAkcItFpKuYcNclnVwTtd1vEKRbos13pk5DQtHcAWkmxkiiYjtkh19MTuQAe4XFiBLzZ9uI9Ju1v+Hk=;
Message-ID: <644607.54176.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: wUYqgo0VM1loPeAzYC7mun_XC9bXKLp55DKvY4rFxEXz_b8
 XNtTVM181v6nsZKh_7hnS2VTt9LiJNjbYlECMYL6ODDsdo6sNKov0VsJIa5r
 RMsJdfp8Y1jMjNn3sCQcElra6BcVWCkEi0W_ki1HqvraUNs5wnqzbY0mf68.
 M9MgNKlQCL69T2pFqjuxZlUUq6AucCxsc94uzAk6cWhp835UDGMZltQ1zLGL
 2vzdimB8tEyLjhP8zgPATNw663HfeqsC8Kk.TGIGn_hIWwA7YRbn.2vE2rZU
 6SKj2e9l.cQVWMgtUBzfrbkE670QP2eqX825dxu5Emz.dNbn2mxOLEE8ZglK
 v3ep17sb1vw1o_Md1KprQmeHxcMbl6w--
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Thu, 1 Jul 2010 03:09:48 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] USB: gadget: mass storage: use proper device class in device desc
To: linux-usb@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <59b191a020300966e20eef4e942bc75982d792fb.1277735580.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 7/1/10, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:

> to match the real class and protocol instead of leaving it
> as per
> interface.

It works now though ... why change it,
and risk causing breakage??
 
>
> 
> Each time I see the device descriptor of the File Storage
> Gadget
> I wonder if it shouldn't be set to the real value rather
> then leaving
> it as per interface.
> 
> Is there a reason to leave it as per interface?  Will
> chenging it to
> the real value change anything?
> 
> I checked my pendrive and an IDE<->USB adapter they
> as well use a per
> interface class ...


