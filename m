Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab0LOQ3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:29:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab0LOQ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:29:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 6/9] ARM i.MX51: Add IPU device support
Date: Wed, 15 Dec 2010 17:29:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Zhang Lily-R58066" <r58066@freescale.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <201012151649.45199.arnd@arndb.de> <87pqt3c89f.fsf@lechat.rtp-net.org>
In-Reply-To: <87pqt3c89f.fsf@lechat.rtp-net.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151729.34021.arnd@arndb.de>
X-Provags-ID: V02:K0:3AEw9RQ9EZnr3dWtK0erd8CsMCMSzKp1WNV3VnUp5sF
 PsDN6VqaPxuN8HJinfFYdlHYT4ryJjxSGssgccQUtQNlvparY5
 ZwWCXQclfg5KZc2fBQtgmL7te12Qn4gbNNdvhv64YEuXH0B/mS
 jazxXd7bvgMPtF0+E1anExEHAE2iyItTXQIT6X0d8K//4KQdF3
 zflvhSmT2EFXyQLtkwhEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 December 2010, Arnaud Patard wrote:
> The thing is that I would consider removing the imx*add* stuff to be
> a cleanup and should be done in a different patch, not in a patchset
> adding IPU support for imx51.

Yes, that sounds reasonable.

	Arnd
