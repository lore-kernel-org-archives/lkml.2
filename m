Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1L1QzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 11:55:03 -0500
Received: from smtpq2.gn.mail.iss.as9143.net ([212.54.34.165]:42149 "EHLO
	smtpq2.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105Ab1L1Qy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 11:54:59 -0500
Message-ID: <4EFB49E2.7010404@gmail.com>
Date: Wed, 28 Dec 2011 17:54:58 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andre Guedes <andre.guedes@openbossa.org>
CC: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [bluetooth] linux-3.x regression (bisected)
References: <4EF3BACA.1080405@gmail.com> <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com> <4EFA1EB8.9090005@gmail.com> <20111227203008.GA13870@joana> <4EFA447C.3030906@gmail.com> <20111228012248.GC13870@joana> <20111228012850.GD13870@joana> <4EFA7696.6060506@gmail.com> <20111228155225.GA23292@joana>
In-Reply-To: <20111228155225.GA23292@joana>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Ziggo-spambar: -
X-Ziggo-spamscore: -1.3
X-Ziggo-spamreport: ALL_TRUSTED=-1,BAYES_00=-1.9,FREEMAIL_EXTRA=2,FREEMAIL_FROM=0.5,HK_MUCHMONEY=0.3,PROLO_TRUST_RDNS=-3,RDNS_DYNAMIC=0.982,SPF_NEUTRAL=0.779
X-Ziggo-Spam-Status: No
X-Spam-Flag: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28-12-11 16:52, Gustavo Padovan wrote:

> I think this patch can do handling, let's see what others think.

I can confirm that this works for me.

Might it be useful to specify the currently observed crap dongle (ie, 
USB 1131:1004) in the changelog or comment? That way, if the handling 
ever changes in the manner that David suggests, maybe this specific 
dongle will find its way into the list immediately.

But... works for me as is.

Rene.
