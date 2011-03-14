Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab1CNQAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:00:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab1CNQAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:00:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Mon, 14 Mar 2011 17:00:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: matti.j.aaltonen@nokia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103141634.10865.arnd@arndb.de> <99B09243E1A5DA4898CDD8B7001114481082FAE15A@EXMB04.eu.tieto.com>
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481082FAE15A@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103141700.26457.arnd@arndb.de>
X-Provags-ID: V02:K0:dzP4yZOK37/o8L7qjFEnS2hiSNBS7MN+C1GmaDllAvA
 03z03rdhvigD0NKsZNzFxHZ6DwVHBDrr2eLooDDrbkYV7qo5yH
 wKjtSQOleMvJB0N2qQn85rsSBfWjEub/G0qISerfspaYOvx5qm
 i9utjj9+srKjrZgdytORq10bh4jbMOlzqcKNPZ1pQ0lXgqClIZ
 IQMJpyoZsRT8dCEMFlVkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 March 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> >
> >If the usleep_range is trying to synchronize between the NFC 
> >and the I2C chip, you must wait for a notication from the NFC 
> >hardware that it's done.
> 
> No, it's simply there as I have been faceing i2c write error while
> I do two consecutive writes.
> The second fails now and then. That's seems to be a chip issue.
> I will try to investigate this issue.

Ok. It sounds like a bug in the i2c driver, you should also take
a look there. Maybe it has never had to deal with this much
write data at once.

	Arnd
