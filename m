Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1AFXMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:12:34 -0500
Received: from nm15-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.208]:29425 "HELO
	nm15-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751914Ab1AFXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:12:33 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 761224.36964.bm@omp1010.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=6Cy4ApFOpPiCbAbZhBzyRiQqTA4hnzBY7jMY4sptIoXB1V034IxGZZjttcBcoFKQN77p+KDlq+4aep3pEJ78AEpyWVW37m3Q8Pvvzn9EbA23KGgxt+xSB8/uuLJsyQqsEydA0yyyQM7GSQgKpiPfAue8VxLvz4vUroPNIoG1sQQ=;
Message-ID: <342889.19810.qm@web180314.mail.gq1.yahoo.com>
X-YMail-OSG: TnF_7xUVM1mQvlDCMkRDpnNEoyrJtyKt5TsCRDR.dxoVLQJ
 9XklTUx4rUsWuONjZVsBLMpl5wvMqqjnyAURvXo5Rci_mn7pZQZKLAzhGMj0
 u7hmx8Ma6tWeRNXy0qOomnGZJD1zJLirkTPXlSdrvUl9uGw9P8G2uKhvmdD4
 _VNd_X1HKrod92ixQwEjPuHQzGlXhbZndcHzDxTfG5OI_dexJ1v3xM6cGbJn
 tZFkwi_ZY3Efr_185dHIOMjJKZPn0Jbb.9mWos6bPyREkg8tAcmY10pYwozg
 Lu6.8yUjQmvXe1Us6dAPJSdP.edcPR5Eu9SOgufuV7kNSif98TIm_hqV94BV
 hjrZzo0Awf2g1o._m_H2Ff9dFAh73eUI6k6_xCF3e2EG4jLZVFwcrr.Fc8GL
 Wa88ivwsFNeILhiavbA--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Thu, 6 Jan 2011 15:12:31 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 3/3] gpio: Add support for Intel ICHx/3100/Series[56] GPIO
To: linux-kernel@vger.kernel.org, Peter Tyser <ptyser@xes-inc.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
In-Reply-To: <1294343654-20354-3-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Interesting.  I had an ICH8 (plus) driver at
some point, but held back doing anything with it
because of the ACPI interactions needed on most
relevant hardware, for wakeups and other issues.
Regardless, I'm glad to see someone pick up on
the fact that these are just GPIOs, and that Linux
should be able to work with them

- Dave

