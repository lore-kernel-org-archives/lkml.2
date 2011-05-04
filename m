Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1EDNhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:37:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62950 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1EDNhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cFRymVOxW01mkBPxKTyq2dwPcDOhsZZcLfnK6XXnPd7dkZ/ufcF1FL8ngtBRGhnkFr
         8uriy3IJArZrA0J0WThT9BnUGiPJaYxC8/73el/7EQ370z1Ig4kRuKzGIdpj8UQWLquI
         bypt67y1YDlk5OrUufON2fMK7/gVEFbH30BS4=
Message-ID: <4DC1568B.2080004@gmail.com>
Date: Wed, 04 May 2011 15:37:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Eibach, Dirk" <Eibach@gdsys.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: msleep() an load average
References: <48D3D52125C49B43AE880038E2E5314BB5BE9D@SRV101.gdsys.de>
In-Reply-To: <48D3D52125C49B43AE880038E2E5314BB5BE9D@SRV101.gdsys.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 02:11 PM, Eibach, Dirk wrote:
> while(1) msleep_interruptible(1000);
> 
> I appreciate their admiration, but still there are doubts in my mind: Is
> this code really any better?

Try to send it a signal, it will eat 100% of CPU without sleeping.

> Is the loadavg metric broken beyond repair?

No, this is expected behaviour. Uninterruptible sleeps count as I/O load.

regards,
-- 
js
