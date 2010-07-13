Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0GMStQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:49:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45840 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab0GMStO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dlxd85TKUXjUudiWE4r9lVCeRpMbgUMmbeLH0Yri5t3g82yat8U7T4vZu1SU1X1thM
         fqesG4vII7IU57m8o2lN6Mu0k5dtTgc+FQw7dhwyEGbdKnUs9mYx+4boRE0T2AJww92V
         8Zqx2OVl1dy150HYgjoo0Mqgrns4SkuEz7n9A=
MIME-Version: 1.0
In-Reply-To: <20100713181212.GB20289@feather>
References: <AANLkTikFmeXz9og4t98jm6QcAdRa6rIeCAv3oeFnTgd8@mail.gmail.com>
	<1278751162-10053-2-git-send-email-jslaby@suse.cz>
	<20100710090705.GA14881@feather>
	<AANLkTimf821jhfhU-Rsj7xa2S4EzuP23weoUSZVWsD2u@mail.gmail.com>
	<20100713181212.GB20289@feather>
Date: Tue, 13 Jul 2010 11:49:12 -0700
Message-ID: <AANLkTinC0TTj1KLp-l_GWO79V4tX4Q62WVEH77_imEtL@mail.gmail.com>
Subject: Re: [PATCH 2/2] parser: define __builtin_unreachable
From: Chris Li <christ.li@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 11:12 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> No, I didn't mean that using __builtin_unreachable should mark the
> function calling it as noreturn.  I meant that as an approximation to
> the right behavior, __builtin_unreachable *itself* could have attribute
> noreturn.

Ah, that make sense.

Chris
