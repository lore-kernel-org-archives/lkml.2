Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab1F2LmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:42:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1F2Ll6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:41:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/2] PWM: add pwm framework support
Date: Wed, 29 Jun 2011 13:41:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Matthias Kaehlcke <matthias@kaehlcke.net>,
        Lothar =?iso-8859-15?q?Wa=DFmann?= <LW@karo-electronics.de>
References: <1309338215-10702-1-git-send-email-s.hauer@pengutronix.de> <1309338215-10702-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1309338215-10702-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291341.48317.arnd@arndb.de>
X-Provags-ID: V02:K0:3D5IGoSB6c5TYYTby5CaNCokBFkQDadlGLjTS/P921v
 21tenDx9UtZhl0NcVJx3T5fmo+44vavl3PXtWqj+k2B0jfgpf1
 vBmM+eUCG1ASSQiOZulg//ObHs17vRmZb2RX4Rc5F8UDXVjW1P
 JjrWywAGvfaNoxBKVA6j9oIXDSVuFegL8loBvCAAqj0kwU6n8h
 DrBJHeWgfbI7mFYik06qA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 June 2011, Sascha Hauer wrote:
> This patch adds framework support for PWM (pulse width modulation) devices.

Hi Sascha,

The code looks all good now, but it seems you missed the three trivial remarks
I had about the documentation. It would be good to just fix them, but not
essential.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
