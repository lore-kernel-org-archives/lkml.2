Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1LMNlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:41:20 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:37369 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1LMNlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:41:19 -0500
Message-ID: <4EE755F6.1020905@eukrea.com>
Date: Tue, 13 Dec 2011 14:41:10 +0100
From: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Sascha Hauer <kernel@pengutronix.de>, Jason Liu <jason.hui@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/19] clock-imx35: fix reboot in internal boot mode
References: <1323757911-25217-1-git-send-email-eric@eukrea.com> <1323757911-25217-9-git-send-email-eric@eukrea.com> <4EE72E57.6080400@ru.mvista.com>
In-Reply-To: <4EE72E57.6080400@ru.mvista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 13/12/2011 11:52, Sergei Shtylyov a écrit :
 > {} not needed -- scripts/checkpatch.pl should have warned you.
 >
it failed to do so :
$ ./scripts/checkpatch.pl 0009-clock-imx35-fix-reboot-in-internal-boot-mode.patch
total: 0 errors, 0 warnings, 11 lines checked

0009-clock-imx35-fix-reboot-in-internal-boot-mode.patch has no obvious style 
problems and is ready for submission.

Eric
