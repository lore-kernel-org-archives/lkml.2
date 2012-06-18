Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2FRPTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:19:08 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:53643 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751016Ab2FRPTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:19:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4FAOFF309bdWObgWdsb2JhbABFrS6ILSIBARYmJ4IZAQUyAQUdIwEQCyEWDwkDAgECAUUGDQEHAQGIC7g6kXIDlSSSXw
X-IronPort-AV: E=Sophos;i="4.77,431,1336341600"; 
   d="scan'208";a="928144180"
Message-ID: <4FDF46E7.9080605@igalia.com>
Date: Mon, 18 Jun 2012 17:19:03 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] Staging: xgifb: Remove XGIFAIL() macro and its calls.
References: <cover.1340016625.git.magomez@igalia.com> <7d6346bfccd6b00f7718b8d4ec9a8543871cf580.1340016625.git.magomez@igalia.com> <20120618150434.GL4400@mwanda>
In-Reply-To: <20120618150434.GL4400@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -	if (!(htotal) || !(vtotal))
>> -		XGIFAIL("XGIfb: no valid timing data");
>> +	if (!(htotal) || !(vtotal)) {
>
> Don't resend this, but next time feel free to write this like:
>
> 	if (!htotal || !vtotal) {
>
> We do have a one change per patch rule but tiny formatting things
> like that don't count as a change.

Sure. I'll write it down together with your other comment to my next 
round of patches ;)

Regards!

-- 
Miguel Gómez
Igalia - http://www.igalia.com
