Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2CFHgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:36:41 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:33536 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757881Ab2CFHgj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:36:39 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Feng Tang <feng.tang@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-eg20t: Rework pch_i2c_wait_for_bus_idle to reduce wait time
Date: Tue, 06 Mar 2012 08:36:37 +0100
Message-ID: <2041940.hOTQq1CLVz@ws-stein>
User-Agent: KMail/4.7.4 (Linux/3.2.1-gentoo-r2; KDE/4.7.4; x86_64; ; )
In-Reply-To: <CANKRQniA2icHddFG22r7VtLTuoefbK61tpcUQnXgShFHuffUuA@mail.gmail.com>
References: <1329725656-32715-1-git-send-email-alexander.stein@systec-electronic.com> <20120301101502.GB2535@pengutronix.de> <CANKRQniA2icHddFG22r7VtLTuoefbK61tpcUQnXgShFHuffUuA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 2. März 2012, 09:51:29 schrieb Tomoya MORINAGA:
> 2012年3月1日19:15 Wolfram Sang <w.sang@pengutronix.de>:
> > Ah, thanks for the update! Are you fine with the patch in question now?
> 
> Alexander's patch looks good.
> Did Alexander test i2c-eg20t driver with this patch ?

Yes, I did test it.

Best regards,
Alexander

