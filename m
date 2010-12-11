Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0LKDkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 22:40:52 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:40977 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0LKDku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 22:40:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VozW0SJA2JindOyqIn3IJnXFynYUBJKNns3rDq9714J5FbkMlm+m8ILLyEHgQ/s/eF
         k77HlHm7ogQRs1NaaAZ3+y4ijnBmu5ftvlHLidTULJksJ12RJ6UbiweTAbEz1ew8xaT0
         T2BcRiUbiQAhZgBAp+LIpgnz7wpOubo9evIb8=
Subject: Re: [PATCH] ata: pata_at91.c bugfix for high master clock
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        geomatsi@gmail.com
In-Reply-To: <1292011430-20835-1-git-send-email-plyatov@gmail.com>
References: <1292011430-20835-1-git-send-email-plyatov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Dec 2010 06:40:45 +0300
Message-ID: <1292038845.6050.1.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a typo in the patch description:
> The AT91SAM9 microcontrollers with master clock higher then 105 MHz
> and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
> lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and pata_at91
> driver does detect ATA device.

"...driver DOES NOT detect ATA device."


