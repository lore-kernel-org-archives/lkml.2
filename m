Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab0IUWSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:18:55 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:42856 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503Ab0IUWSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:18:54 -0400
Message-ID: <4C992F2C.1070601@euromail.se>
Date: Wed, 22 Sep 2010 00:18:20 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] hid: 3m: Adjust major / minor axes to scale
References: <4C992775.3000000@euromail.se> <B4B2743B-D21F-4EC2-8E1E-5C52C78B5AF6@enac.fr>
In-Reply-To: <B4B2743B-D21F-4EC2-8E1E-5C52C78B5AF6@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OyBAQ-0000my-9H.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OyBAQ-0000my-9H 36d33574900374d07f8b699eee000e41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 11:51 PM, Stéphane Chatty wrote:

> No problem with this one at all.
> 
> Henrik, do you confirm that this applies only to 3M? Or is it a general issue
> with the mapping from HID to input?


Of the devices I have seen so far, the touch width mapping is fairly arbitrary.
Some are too large, some are too small. Regarding HID drivers in general, I
really cannot say. No particular pattern so far, in other words.

Cheers,
Henrik
