Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0H3QEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:04:40 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:32824 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab0H3QEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:04:38 -0400
MIME-Version: 1.0
Date: Mon, 30 Aug 2010 11:04:39 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hemanth V <hemanthv@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <igor.stoppa@nokia.com>, <kai.svahn@nokia.com>,
        <matthias.nyman@nokia.com>
Subject: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input: CMA3000
 Accelerometer driver)
In-Reply-To: <20100829184904.GC26209@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com> <20100829184904.GC26209@core.coreip.homeip.net>
Message-ID: <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

When we tried to push N900's accelerometer driver as an
input device you commented you didn't want sensors such
as accelerometers, magnetometers, proximity, etc on the
input layer because "they are not user input", although
I didn't fully agree with you, we had to modify the drivers
and, I believe, one of them is sitting in staging under
the industrial i/o subsystem.

Are you now accepting sensor drivers on the input layer ?
that will make our life a lot easier but we need some
definition to avoid having to re-work drivers when we
want to push them to mainline.

-- 
balbi
