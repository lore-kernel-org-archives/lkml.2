Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437Ab0KPNJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:09:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50843 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab0KPNJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:09:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Obi9d576oYWUyhgjyMCaa9/Jd7kv9/GU0yI9OA2KVedAXCKqzZ4nYnbjFHrFjTcX2M
         h1SK5lcjUMqOt+qTg9lIpFQTaRfd4Shy+xnkWo07phBoYlbm8Ag3ksqNcSEPaxhCS0Db
         ukZotXNqRPg4MIQJr7j7G6932+yXtMcfz8eHo=
Message-ID: <4CE28299.30907@suse.cz>
Date: Tue, 16 Nov 2010 14:09:45 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Baruch Siach <baruch@tkos.co.il>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Gershgorin <agersh@rambler.ru>,
        "Indan Zupancic" <indan@nul.nu>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>	<4CE0FE71.6000303@suse.cz>	<20101115100838.GA3649@jasper.tkos.co.il>	<4CE10B32.8090705@suse.cz>	<c30e46c1b5343789b6475722071c3020.squirrel@webmail.greenhost.nl> <20101116110444.2f0cabd9@lxorguk.ukuu.org.uk>
In-Reply-To: <20101116110444.2f0cabd9@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 12:04 PM, Alan Cox wrote:
> Sixteen devices is way too many for drivers/misc - it only has 256 total
> and only half of those are dynamic.

Seconded. (And it's a quarter, not even a half like I already wrote.)

regards,
-- 
js
suse labs
