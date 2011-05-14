Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab1ENTJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 15:09:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41143 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1ENTJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 15:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rzfgdD9qb+07yv93scIb6vCBTzItT1AVt2NTudsfU1F4UZgiIjl3Kk8ROz/E3sOITL
         U3Rh61oK1VA/Pw6WHFRX4qoj1YwiyFrv1j+As093Z+u5TsgItfelzWDHk25qv7OHuJaa
         2cAQqWZ9OXIKycpwaTS09uY1lSaYBqm8q8sy8=
MIME-Version: 1.0
In-Reply-To: <20110430100750.0b49ff20@debxo>
References: <1304166750-31125-1-git-send-email-dsd@laptop.org>
	<20110430100750.0b49ff20@debxo>
Date: Sat, 14 May 2011 20:09:35 +0100
X-Google-Sender-Auth: H0TPC9OQhsT5AA-p0e5v4YuBpCM
Message-ID: <BANLkTi=Cica7Sj3ty+xxe+k7b+fUBS9VxA@mail.gmail.com>
Subject: Re: [PATCH 0/11] OLPC Power Management
From: Daniel Drake <dsd@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 30 April 2011 18:07, Andres Salomon <dilinger@queued.net> wrote:
> On Sat, 30 Apr 2011 13:32:19 +0100
> Daniel Drake <dsd@laptop.org> wrote:
>> These patches implement various power management features on the XO-1
>> and XO-1.5 laptops.
>
> Great, thanks for sending!  Feel free to add my Acked-by to all of
> these.
>

Just a quick reminder on these patches - still awaiting review
comments. I'm available to make changes based on people's comments.

Thanks,
Daniel
