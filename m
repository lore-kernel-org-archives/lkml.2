Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2EHN5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:57:09 -0400
Received: from nm4.bullet.mail.ird.yahoo.com ([77.238.189.61]:22172 "HELO
	nm4.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755110Ab2EHN5H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:57:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 56371.58357.bm@omp1035.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=SrUv+iZY7jsB0XvQUtfS+Vt5pNhe8n86kN4YNaMWfJyz5yYR0ybfUYa5pqqseNN8e8PKY2a2/Rn10jDNXRDGYx3MaJ+dSVi67rfEdeeYyVaJR7SdQy9TZtcZF/jjVpT18D+Ny8xarQXvAWVVgz0p/6W8Sj3E+G9Vnxg+j4O6gS0=;
X-YMail-OSG: LusbV70VM1kVBhNtQwrhKWVUQieIVF0VfykPep3XnphrTbg
 SSkryXcMW9cLpffOn760sKje.CtjE_uRxc1Pq5gyuFZEhE5xm8k3.BefThSe
 4ABbhGiP9AvlBsuvkLYtPG__EQ2S35ExK7xo0Ru_nyOGVTB6I8b0cS6Eg6UH
 lMYWIP1glqk6g.zl4DGQMR4c.BONBM6X3oIaUElNfrZwxGkcXCGrtNzp9oS_
 3S_uwU91Ta.LzjJFpOeuaT4bEE3EiYTRgm2VJAcEHaZf4y..uefK03VkdzQd
 CxkPHAN2I4RjHG3J.28S6DmiYCfdarPy0wkEECJwGZfpqELnU1gowU7hmZ1E
 iQa14vSSR3QPNbwgnQ8DiE0s_zMWZqA2EjQCB7VCZeHSsjJEf0ChWjPD5pNo
 WnFvJgOGbk_9J3pohRhuQuM_il7B.hwoV5z9jB4VQ
X-Mailer: YahooMailClassic/15.0.6 YahooMailWebService/0.8.117.340979
Message-ID: <1336485424.10001.YahooMailClassic@web29019.mail.ird.yahoo.com>
Date: Tue, 8 May 2012 14:57:04 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH] ARM: mach-pxa: Use REGULATOR_SUPPLY macro
To: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1336465510.11954.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Axel,

--- On Tue, 8/5/12, Axel Lin <axel.lin@gmail.com> wrote:
>  arch/arm/mach-pxa/hx4700.c    |   13 ++++---------

The hx4700 patch works for me on linux-3.4.0-rc6.

Tested-by: Paul Parsons <lost.distance@yahoo.com>

