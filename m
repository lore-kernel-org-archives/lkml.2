Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab1CWQNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:13:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54897 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab1CWQNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:13:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar HJALMDAHL" <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: Re: [PATCH 2/2] mach-ux500: Add CG2900 devices
Date: Wed, 23 Mar 2011 17:13:40 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
References: <1300888803-26474-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com> <201103231542.28311.arnd@arndb.de> <AFCDDB4A3EA003429EEF1E7B211FDBBA334C4DE937@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <AFCDDB4A3EA003429EEF1E7B211FDBBA334C4DE937@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231713.40311.arnd@arndb.de>
X-Provags-ID: V02:K0:87h+gp4TJXQLwrbFU+LPZM5ZYglmpsqWWqDgev4FR3T
 x0OMyL/9pw8EaWWAOYgQieKP+k3VKL8ro5kJzXebcHtQ7PRFLB
 Sg7iNmwXyHoiC/Njb7KnOk4/2R6NlWL3WasfmcaFnT8tWaqA5c
 QGrFh0CO5AUfSTJCgGL/z/Ynwhd5hjOJicUMaOZbB/BwcwAE/K
 +0LbgIqw9GrmADlS6BqBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011, Par-Gunnar HJALMDAHL wrote:
> I will see how I can fix this. I'm not 100% how I will solve the
> "asking the hardware" part, but as you say we might be able to do
> this in a better way by doing it from the main staging driver instead.

The easiest way to do this would be to have separate board files for
devices with and without cg2900 and identify the hardware based on the
board number. If all ux500 boards have a cg2900, that would be trivial ;-)

	Arnd
