Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1LMKOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:14:08 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:39397 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1LMKOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:14:06 -0500
Message-ID: <4EE7253E.2030604@eukrea.com>
Date: Tue, 13 Dec 2011 11:13:18 +0100
From: =?ISO-8859-15?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: linux-arm-kernel@lists.infradead.org, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/19] eukrea-cpuimx51: remove board
References: <1323757911-25217-1-git-send-email-eric@eukrea.com> <1323757911-25217-16-git-send-email-eric@eukrea.com> <20111213100532.GH27267@pengutronix.de>
In-Reply-To: <20111213100532.GH27267@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

Le 13/12/2011 11:05, Sascha Hauer a écrit :
> On Tue, Dec 13, 2011 at 07:31:48AM +0100, Eric Bénard wrote:
>> this board is not maintained anymore and is replaced by cpuimx51sd
>
> I'm happy to remove this code, but aren't there any users of this board?
>
not any that would need a kernel upgrade considering the Freescale proprietary 
drivers used on it :-(
Thanks,
Eric
