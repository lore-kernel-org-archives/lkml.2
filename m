Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0LOKul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:50:41 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:44654 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653Ab0LOKuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:50:39 -0500
Message-ID: <4D089D59.9030007@euromail.se>
Date: Wed, 15 Dec 2010 11:50:01 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Richard Nauber <richard.nauber@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: egalax: Extend support for touchscreen used in "Samsung
 NB30 touch" netbook.
References: <1292362579.2232.84.camel@itzy>
In-Reply-To: <1292362579.2232.84.camel@itzy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PSovq-0008Q4-5y.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PSovq-0008Q4-5y 2a5f9351ef6450c8123ef0d32e73221d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

> I got me a brand new "Samsung NB30 touch" and with this patch I have

> the full multitouch power at my fingertips. At least at two of them... 


Thank you very much for this patch. Will be applied.

> BTW: I have not found a suitable tuio bridge for linux mt devices, 
> so I wrote a small mtdev2tuio tool. It uses libmtdev and liblo 
> and allows to interact with lots of existing software (e.g. a 
> compiz plugin, numtyphysics, ...). If someone is interested, I 
> can upload it (might take a while).


Very nice! If you have a git tree, that would be fantastic.

Thanks,
Henrik
