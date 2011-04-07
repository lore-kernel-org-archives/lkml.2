Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab1DGXgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 19:36:02 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59786 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab1DGXf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aHbRcccCiriLlGGSMwyOsfeV3Q7AfoVSaF1SghQOl4ioJ7yvOonNECj0xLpItu9xpd
         RBgaX61v19AtEkJl7uQjLtKhE287gyzQzSFIJ0TFrWiDklcyrD73IAKNP2LQmOxE5GT8
         QZbNlDwpl92iQKrIyL5X3m3n43332TGf3FRBg=
Message-ID: <4D9E4A59.8010604@gmail.com>
Date: Thu, 07 Apr 2011 16:35:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: trivial@kernel.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        socketcan-core@lists.berlios.de, linux-mtd@lists.infradead.org,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/6]Fix typo "recieve" in various parts of the kernel.
References: <1302192567-842-1-git-send-email-justinmattock@gmail.com> <20110407200541.GC8569@pengutronix.de>
In-Reply-To: <20110407200541.GC8569@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 01:05 PM, Uwe Kleine-König wrote:
> On Thu, Apr 07, 2011 at 09:09:22AM -0700, Justin P. Mattock wrote:
>> The patch below fixes some typos "recieve" in various parts of the kernel.
>> Note: these below are in actual code rather than comments(excpet for r852.c which
> s/excpet/except/
>
>> has a code fix, and comment).
>> compile tested as best as I can...
> I'm not a native speaker, but "as good as" sounds better in my ears.
>
> Best regards
> Uwe
>

your right.. gcc and friends are the one's doing all the reall work:
"as good as *"

Justin P. Mattock
