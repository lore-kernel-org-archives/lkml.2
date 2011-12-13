Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1LMKyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:54:32 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:48278 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752465Ab1LMKya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:54:30 -0500
X-AntiVirus: Checked by Dr.Web [version: 6.0.3.08040, engine: 6.0.100.10070, virus records: 2434158, updated: 13.12.2011]
Message-ID: <4EE72EAB.4040308@ru.mvista.com>
Date: Tue, 13 Dec 2011 14:53:31 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
CC: linux-arm-kernel@lists.infradead.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 08/19] dma: MX3_IPU fix depends
References: <1323757911-25217-1-git-send-email-eric@eukrea.com> <1323757911-25217-8-git-send-email-eric@eukrea.com>
In-Reply-To: <1323757911-25217-8-git-send-email-eric@eukrea.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 13-12-2011 10:31, Eric Bénard wrote:

> ARCH_MX3 was removed in e760b5260d39113794da17c64cbd6e6311155b66

    Please also specify that commit's summary in parens.

> thus preventing to select MX3_IPU, thus preventing IPU and display
> to work on i.MX3x SOC.

> Signed-off-by: Eric Bénard<eric@eukrea.com>
> Cc: Sascha Hauer<kernel@pengutronix.de>
> Cc: Vinod Koul<vinod.koul@intel.com>
> Cc: Dan Williams<dan.j.williams@intel.com>

WBR, Sergei

