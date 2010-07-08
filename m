Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab0GHUUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:20:15 -0400
Received: from n1-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.152]:43250 "HELO
	n1-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752272Ab0GHUUM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:20:12 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 556441.52579.bm@omp124.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qLgZpfmCMruDT8+Rsy4JifD8JsIy0r2+CfpHHFCAq7GDCI+FCwS8AdEjt0I+Y8ONLiAidPCzo48lcpNKYA+SrukZIT4vUIHJqo94MeuA0SlcZ4kk20kyPVGw4QqOiHkDFZ8P0r2HY27ndnlebXyAJIV7j0dyVmWnoUK/yhgL184=;
Message-ID: <425855.73532.qm@web180314.mail.gq1.yahoo.com>
X-YMail-OSG: Iw9rwZEVM1lbSgUGQQ0Djkdkn0etPvIwexJ5KkVcw4TbiaB
 poqw1hRhtE0BYly8PbsRFjWlonsA0PZmIxVMGBzqidaH_KewBTe42DBc7vJO
 ZvGz03aRKBbcI3G.Ppwr_sRng_P0GbSxUjBH8tAHyX3Ag07kH9n8sZSroxAS
 a5EbD0uKR5mQKsxd81iZE_8pu11Wk6HpR_31o9ndfsjLOD7RRQs5a7ga7Xzs
 9.YCsQVePvUw7xIczsfhXV_a7Sn3T6mf3LKTMYJijhonc_g2uoWbXKDcAlHu
 jwMUtxREomP7TfhwdmCJlHPLkTIyd9DQ6Qq1QDGQ91EDu0qsOyJl2Rg--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.274457
Date: Thu, 8 Jul 2010 13:20:11 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv2 1/2] USB: gadget: mass/file storage: set serial number
To: Greg KH <greg@kroah.com>,
       =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
       mina86@mina86.com
In-Reply-To: <op.vfjja62m7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can it be made to do so only when the gadget
> > hasn't been provided with one already?  Serial
> > number module options are standard parts of the
> > composite gadget framework...
> 
> I don't see a way for the gadget to know whether user gave
> the iSerialNumber
> parameter (other then reading the iSerialNumber variable
> but I consider that  ugly).

Uglier still is the current patch overriding
that explicitly-given parameter.

NAK until this issue is resolved.



