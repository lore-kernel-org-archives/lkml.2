Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab1GAR4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 13:56:07 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:47097 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756486Ab1GAR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 13:56:05 -0400
From: Nathan Royer <nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<1309486707-1658-11-git-send-email-nroyer@invensense.com>	<20110701085604.0aabd6f1@bob.linux.org.uk>
	<CAN_12A8Za7r92=r3JHx3R=AwAA7xk6=NVVMiSp68HPatb1G3hg@mail.gmail.com>
	<20110701154150.0ac303a3@lxorguk.ukuu.org.uk>	<CAN_12A9jvid+7u5mOHbFBqE+Xtb6kbo_endwRk98JLrGK2E2TA@mail.gmail.com>
 <20110701180046.20efb83e@lxorguk.ukuu.org.uk>
In-Reply-To: <20110701180046.20efb83e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Acw4ECitwcMi+BbgQOKUhTwG8jxmFAAB7ptQ
Date: Fri, 1 Jul 2011 10:56:01 -0700
Message-ID: <a7e9c284c685826bdb9853cae289c499@mail.gmail.com>
Subject: RE: [PATCH 11/11] misc: Add slave driver for bma085 pressure sensor
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Wolfe <cwolfe@chromium.org>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added an explanation of some of the high level bypass mode work which
is done in mldl_cfg.c in response that patch

[PATCH 05/11] misc: MPU3050 and slave device configuration.
