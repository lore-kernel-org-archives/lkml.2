Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab1AJSB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:01:58 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:40021 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab1AJSB4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:01:56 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net BA4F35A421
Subject: Re: [PATCH] DVB Satellite Channel Routing support for DVB-S
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: =?iso-8859-1?Q?Thomas_Schl=F6ter?= <thomas.schloeter@gmx.net>
In-Reply-To: <4D2B2BA6.7030009@linuxtv.org>
Date: Mon, 10 Jan 2011 19:01:47 +0100
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E063370D-7EC3-4E21-8B25-AE3064FA6FB1@gmx.net>
References: <BDD0B014-3AD5-4693-82D9-026F47A7F8A4@gmx.net> <4D2B0521.1020404@linuxtv.org> <C8296DFF-0E53-4AA2-A6ED-CA8B83D424F2@gmx.net> <4D2B2BA6.7030009@linuxtv.org>
To: Andreas Oberritter <obi@linuxtv.org>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 10.01.2011 um 16:54 schrieb Andreas Oberritter:
> 
>> - In many TV recording applications there is no support for SCR and it would be harder to implement in these. For VDR, there is a patch which is difficult to configure and has some technical limitations. In MythTV and XMBC I could not find any support for SCR. Their Wiki pages or forums say, that there are no plans for Unicable support as it would take huge changes.
> 
> Many of these applications didn't or don't support DiSEqC 1.1
> (uncommittted switches) or DiSEqC 1.2 (rotor commands) or USALS. Still,
> we don't put this logic into the kernel to make their life easier.

> Don't add unneeded complexity to the kernel.

I think this is the point we are talking about and I understand the feature might not be critical enough to justify a kernel implementation.

Regards,
Thomas