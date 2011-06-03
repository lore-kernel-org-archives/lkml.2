Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1FCSr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:47:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51268 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab1FCSr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Exlbm3CW6w82SrSOoNKGtKcEB6qTZNA3ZdyR2n1rxtEFL8JfHIE1KgiIU1m/XDMzrP
         ESeK4vLpK0K7UXCvAaMSWS49exDUZ8hukOoYwdidBJGUavXPQIACQrB/4k64fdSA7DeM
         8PIPtd3hlYcFYXmHLkaR8pA6k6/IIExAXYMpw=
MIME-Version: 1.0
In-Reply-To: <4DE92AC0.1000806@freescale.com>
References: <1307119552-15573-1-git-send-email-timur@freescale.com>
	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
	<4DE92675.6080908@freescale.com>
	<BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
	<4DE9294B.3040501@freescale.com>
	<BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com>
	<4DE92AC0.1000806@freescale.com>
Date: Fri, 3 Jun 2011 21:47:27 +0300
Message-ID: <BANLkTik_O2QvXqeY03NU3xP1q0=Dqco6Eg@mail.gmail.com>
Subject: Re: [PATCH] lib: introduce strdup_from_user
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Timur Tabi <timur@freescale.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
        scottwood@freescale.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 9:41 PM, Timur Tabi <timur@freescale.com> wrote:
> Alexey Dobriyan wrote:
>> The point is data should cross kernelspace/userspace boundary only once.
>
> And my new version does that.  I'm just asking if you're okay with it.

It leaks first allocation if second one fails.

Come on.

Show you user in driver, maybe what we're discussing is moot.
