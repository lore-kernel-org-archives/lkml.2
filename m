Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab0DWQDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:03:00 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:57072 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab0DWQC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:02:58 -0400
Date: Fri, 23 Apr 2010 10:02:57 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
cc: linux-kernel@vger.kernel.org, s-jan@ti.com, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] HSI framework and drivers
In-Reply-To: <1272035728-6933-1-git-send-email-carlos.chinea@nokia.com>
Message-ID: <alpine.DEB.2.00.1004231001190.29720@utopia.booyaka.com>
References: <1272035728-6933-1-git-send-email-carlos.chinea@nokia.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-7893282-1272038577=:29720"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-7893282-1272038577=:29720
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

(cc S=E9bastien JAN)

Hello Carlos,

On Fri, 23 Apr 2010, Carlos Chinea wrote:

> I have been working on a new proposal to support HSI/SSI drivers
> in the kernel. I would be very glad to get your feedback about
> this proposal.
>=20
> This patch series introduces the HSI framework, an SSI driver
> for OMAP and a generic character device for HSI/SSI devices.
>=20
> SSI, which is a legacy version of HSI, is used to connect the application
> engine with the cellular modem on the Nokia N900.
>=20
> This patch set is based on 2.6.34-rc3

Have you looked at S=E9bastien's HSI driver code:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg18506.html

Is there some way that you can combine efforts with him?


- Paul
--155748971-7893282-1272038577=:29720--
