Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab2CYUVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 16:21:17 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:52473 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab2CYUVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 16:21:16 -0400
Message-ID: <4F6F7E37.5000209@hrz.tu-chemnitz.de>
Date: Sun, 25 Mar 2012 22:21:11 +0200
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] w1: Add 1-wire slave device driver for DS28E04-100
References: <4F63AF9E.2090000@hrz.tu-chemnitz.de> <20120318214041.GA20521@ioremap.net>
In-Reply-To: <20120318214041.GA20521@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Scan-AV: nick.hrz.tu-chemnitz.de;2012-03-25 22:21:12;75b020b1a128ab8ea2ef78281de33dc0
X-Scan-SA: nick.hrz.tu-chemnitz.de;2012-03-25 22:21:14;a0e3db4ea1c5f10ca0396a5a1ba93543
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

have you received this patch? Just wondering because I have not heard 
something about this anymore from your side.
Please do also have a look at

[PATCH 2/2] w1: Disable irqs during 1-wire bus operations, extend 1-wire 
reset pulse

Both patches have already been signed by Evgeniy Polyakov.

Thanks and with best regards,

Markus Franke

Am 18.03.2012 22:40, schrieb Evgeniy Polyakov:
> Hi
>
> On Fri, Mar 16, 2012 at 10:24:46PM +0100, Markus Franke (markus.franke@s2002.tu-chemnitz.de) wrote:
>> This patch adds a 1-wire slave device driver for the DS28E04-100.
>>
>> It applies to the current linux kernel git tree.
>
> As discussed with Markus already - looks very good
> Greg, please pull it into your tree
>
>> Signed-off-by: Markus Franke<franm@hrz.tu-chemnitz.de>
>
> Acked-by: Evgeniy Polyakov<zbr@ioremap.net>
>

