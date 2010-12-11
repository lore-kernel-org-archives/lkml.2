Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab0LKWKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 17:10:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46628 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0LKWKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 17:10:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p+FhIBOlWd0nHRf54gkl5b7SwgEThH3iGl490RvOUHJNIHiTk1ziYexlQ4Oy5WB+9C
         J3M2CV8DIZtMh661fu3TEbjXo7u8LgKy1/eNGM5ISAJMVNwxcvLhuEhca+eRgf0cxLzn
         +k5kpzbF/ULQG4EEf3eyt+U55/bhcQ2jR6awU=
Message-ID: <4D03F6C3.5030709@pobox.com>
Date: Sat, 11 Dec 2010 17:10:11 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Igor Plyatov <plyatov@gmail.com>
CC: sshtylyov@mvista.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, geomatsi@gmail.com,
        nicolas.ferre@atmel.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        christian.glindkamp@taskit.de, ryan@bluewatersys.com,
        pgsellmann@portner-elektronik.at
Subject: Re: [PATCH v2] ata: pata_at91.c bugfix for high master clock
References: <1292099846-24528-1-git-send-email-plyatov@gmail.com>
In-Reply-To: <1292099846-24528-1-git-send-email-plyatov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2010 03:37 PM, Igor Plyatov wrote:
> The AT91SAM9 microcontrollers with master clock higher then 105 MHz
> and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
> lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and driver
> does not detect ATA device.
>
> Signed-off-by: Igor Plyatov<plyatov@gmail.com>

Thanks, queued (absent further comments...)


