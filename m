Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1AFXQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:16:20 -0500
Received: from nm6.bullet.mail.sp2.yahoo.com ([98.139.91.76]:37817 "HELO
	nm6.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752099Ab1AFXQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:16:18 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 95695.6709.bm@omp1009.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=uorsWq7Skl1+G9ZDe0Z49fv+Kj+082pCayBB6OlIDEMF1e4XYD1C/q8JFxlmJcPQFuo0mWnuYsSuq90SfIPYADCfDiKdCRMIwSKqU76UwWgojWRcIaKF/53nXLzDWLoJquXbrxz5Pp3XH8Fo/GfukXlPfzzEOayNPenjqlYMyXA=;
Message-ID: <411845.63911.qm@web180315.mail.gq1.yahoo.com>
X-YMail-OSG: NxPG.kgVM1lH8H4FN21XG6MZuDkxZ4VoTwdfpC_GBZJCMd8
 2_AyBBCS2XxX19Qb4XY480dAA21BHMHlIuNA7W5W8nRL.oJy2QF.7RcBExfg
 hJIbyVBsrjf4sJBhETbsFK1H0mF8k3jkl.3bUbAEyjzdwpLLzaiYf8gQgQ7d
 jzBEGkjgWuLEvpJvm3DpX4nS2FkgmMt4_wCCvg9UgE9qpJo1Mf03FfNq_BEP
 LnyvT7cdyPBH5cs_cB53xuitIlu8_Nke3Rbt7U5GDI.g410uB0428x4VyXkv
 7dOK6uX67ru3ou7lB1tFL9Lw7MVokdbEQRhriTWpb_ivBiLcgOQfmdlWAYik
 avilw8vJN5aD3YAAhUhCRA70KPW2PzaxNUcdhPN77JdTQlr0H2X6uJi6n6yv
 tzyqs
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Thu, 6 Jan 2011 15:16:17 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 2/3] gpio: pca953x: Implement get_direction() hook
To: linux-kernel@vger.kernel.org, Peter Tyser <ptyser@xes-inc.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
In-Reply-To: <1294343654-20354-2-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 1/6/11, Peter Tyser <ptyser@xes-inc.com> wrote:

> Subject: [PATCH 2/3] gpio: pca953x: Implement get_direction() hook


Ack   This can affect initialization too ISTR.

