Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab0GTOwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:52:34 -0400
Received: from n3b.bullet.mail.ac4.yahoo.com ([76.13.13.73]:29795 "HELO
	n3b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758407Ab0GTOwd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:52:33 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 692254.18867.bm@omp127.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5legExwlfiD/FkWiShQQ+TcgK902Fj6wKQ/HM8Zb2vaXJiPVlO0lIEheevF/ZBgGJhPdU0YVZ1jNWAhqJobsHjenU8TqdvFXmkO9AIpvfLohLZgWgX7+gl9Fs8dw7+harb0rSWQc+mG/SYu1x4ODCgGD8bNVrx0eJ7Lab9GDVDo=;
Message-ID: <491292.34390.qm@web180315.mail.gq1.yahoo.com>
X-YMail-OSG: TRghloEVM1ncoN_c.J0GoS8vNhF7_m2Fz7EVwjpQvKpFEAB
 zXD64z1dyEX9PgOphKlX654mLprpcPZXz9Zhij8fmsuAsAYMYfKRSmFSvTIQ
 mHGdksjeIZmadI34M2NVRbyDsbM28TRTRvv2vDQ2udrKRnAAVLGpGTiH4QZ7
 HwLN_b05RaGmjw3Wzf7r.9l3Y0uK_EKhsOQ7C.GG.fe.zTZTg9fSegol9IdP
 qELRxMp7oxktwRHvpAntchJnUsYy5AnB55gpztzGPs7rdw0xylycUTROw1_z
 V4J5Q.PM8.BMbiI0y3RP6aizLQr5lA4cP9GrylHNRQ.ENkapA0_QW
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.276605
Date: Tue, 20 Jul 2010 07:52:31 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
To: Alan Stern <stern@rowland.harvard.edu>,
        =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
In-Reply-To: <op.vf5cd0ap7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 7/20/10, Michał Nazarewicz <m.nazarewicz@samsung.com> wrote:

> The rationale is that not having to use ARRAY_SIZE() is,
> well, simpler. ;)

And more foolish.  Do work at compile
time, not run time, when it's that easy.

- Dave



