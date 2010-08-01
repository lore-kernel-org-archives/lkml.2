Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117Ab0HATFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 15:05:37 -0400
Received: from n3-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.157]:29333 "HELO
	n3-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750999Ab0HATFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 15:05:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 977975.84211.bm@omp202.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=dWBk12f/kEHrDvPnHkO2vnDeggxJPcePV3G6yl5h7gJuQEEGg3dEmZfkZw3iqoVNRf4xvaixsoGnnbGa1s7fCr9OMh+sDk4vLB8cFzz+x6/HnbI8pihjQXTnNSFv0Qjkw4IreJGuwP3OKnzZ9FEcqW9Q7HMgEG/b7jhGC5uIieE=;
Message-ID: <764692.87858.qm@web180303.mail.gq1.yahoo.com>
X-YMail-OSG: PGDIu84VM1n.yTmRS94f0fJ9.4hiTh9mBbIBudA2_hdzJHD
 Qydu2EAcI8cY5DuFxwrPVU0aVkuZJkMAKmikH6NKb2KdpAKmr2BMZ_v49D.k
 gD2zHxLBM6KpU6rEd7V0QHnPjhau3BpVKJeVkNgmromo6bN9jwpqu7BGSR8S
 4KjCA2U0p.Z2HY.dgbWrP3nXsIU8NgH20X8X5_NJbdNj7A4fTSbVVL7IpDk4
 O_ytwLL9qHVYYXjZVhh4Nev_0i_jJ6MeUNtJiu4uWxl9xDY0_PFueQhfm6jt
 PTkBSKdtQazr9pyk4Ag_SuMnQfBa2R2.uq669fg--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.105.279950
Date: Sun, 1 Aug 2010 12:05:33 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv5 1/3] USB: gadget: composite: Better string override handling
To: Greg KH <greg@kroah.com>, Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <38424b23c94ddcff6f1808161912f362c2ccae39.1280316431.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hope this time everyone will be happy. :)

NAK.  You're still hard-wiring an un-managed
serial number.  How many times do I have to say
I will never accept such a broken policy??



