Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab0FIHh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:37:28 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35579 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab0FIHh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=q9E2C6zxmJy5hdMgfgC4NM17I0UBLkC3qNmbxOzikU/rsC6Q7zzMsy9SuoEPvg3iYB
         FjOqIGodOSNOQFD2g1o4F6nMUr6WtQH9nVGSmhZTzr1BfBR7PBcwQjtuDgAxreeMxX2Z
         J2O4T/byPi5Ot2/w5/FgF4caRIDfC0EVqBKEM=
MIME-Version: 1.0
In-Reply-To: <20100609072546.GB1743@mail.wantstofly.org>
References: <4c0e9ee6.8704df0a.2e71.ffffdf65@mx.google.com> 
	<20100609072546.GB1743@mail.wantstofly.org>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Wed, 9 Jun 2010 10:37:05 +0300
X-Google-Sender-Auth: GidhT-MdmLsSU-ewA-VzSvyWiQs
Message-ID: <AANLkTilfrP0e3RaBV_GnpwG8NBsS4eXWnWOVaQxMrMfo@mail.gmail.com>
Subject: Re: [PATCH] Marvell OpenRD-Ultimate machine support
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Alexander Clouter <alex@digriz.org.uk>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, I've sent the old version.

My apologies. Will resend the updates version as soon as I get access
to the box.

-- Dima

On Wed, Jun 9, 2010 at 10:25 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> On Tue, Jun 08, 2010 at 10:47:47PM +0300, Dmytro Milinevskyy wrote:
>
>> Differences from the previous attempt:
>>  - Applied suggestion from Lennert Buytenhek to change PHY addresses in instances of mv643xx_eth_platform_data in case of ultimate version.
>
> The patch looks exactly like the old patch, though?
>
