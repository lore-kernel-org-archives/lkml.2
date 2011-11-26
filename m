Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1KZTHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 14:07:13 -0500
Received: from nm14.bullet.mail.ne1.yahoo.com ([98.138.90.77]:43214 "HELO
	nm14.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753661Ab1KZTHL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 14:07:11 -0500
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Nov 2011 14:07:10 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 759727.8467.bm@omp1052.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hSk7zyOt5YL97tBBdHXAH2knp3FiPpjkIuqPrCx9rlKXCgvCfs+Vw0QFi0Sl7ifxMYNGBzR8jHa3eOXJyydwLc2r9RYeN1Cr3OVo3hrJNnRSJIcbIbdBBkZ6Ycwf/chGIyTnS1k2mw6QT5P+DWfcaULORKoHgHtJoUCSsQrL454=;
X-YMail-OSG: 2T2XDy0VM1kUgHkzvfUuwoDBl2_y5BlHCdBzoGrajxCFzux
 .VePEvtPgUVVfVL1dVEnTuBvUundFdRPEOJfcGvJ5KNHKI8.pDfUohHxPnT_
 vcmKc2DR8TDIYnJmPjax1leg.L8cPf_dWfM99nsykaBRD94s3JcXfqamA_sq
 rCGcGpojObMp.bCSM4Y7XuD33YbrwZBbn3AmLNdKGpiFqjQ0Jn0pJUig8sVs
 AULrieLhN5rVgpDxXQ0N9LF2wyx0AVPaVf8G0m.BYxkXhcT2qhiaPqXYAct1
 ufRNCb8pYB4DyOfutyHsVX8APr1oB0MLDDHXjs7o2_Wx8NdYAbM9UNnYMO65
 MPSaKoF23ibo_HucWRTgmUFNjmu9JZUXYx.ssw76Frpks3mmH_MBSEZ8uCyx
 PepMTIB4rZ76cZpekjPy5HTTrtm2VZkBejiCCVoS5cGM3jEEQj4PZ8RFpKT3
 ELjjVJ3tqgmvMqZ8iI6PXLsl.eLb5OSWXZPNbGvrYyVK8vcSZatFHukjGp5j
 0nEN4.Hjz3UM-
X-Mailer: YahooMailWebService/0.8.115.325013
Message-ID: <1322334099.97871.YahooMailNeo@web36605.mail.mud.yahoo.com>
Date: Sat, 26 Nov 2011 11:01:39 -0800 (PST)
From: Audio Phile <da_audiophile@yahoo.com>
Reply-To: Audio Phile <da_audiophile@yahoo.com>
Subject: compiling linux 3.1 with icc
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone point me to a guide describing how to build the kernel using the Intel compiler?  As far as I can tell there are numerous files in the kernel tree that need to be edited.  The closest thing I have found to a solution is the outdated linuxdna project, http://www.linuxdna.com/ but it is not updated with the 3.x series.
