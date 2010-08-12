Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab0HLMPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:15:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44217 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab0HLMPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:cc:content-type;
        b=N7xpXVhMoZYHfS+9ka5fGYhHh06VHE2o4EZFG2EvVd2mb1W/Htx/yrUnVEk9jX8F46
         AAhAq0IG0tWAMZZG/RvSBjA1Lmuw2eez42K1FeGdXGakfEsZypJkcy/uHNOffqwL0glA
         sOmT8FduLUk9WEikZU0lrTEWeYyF/6A8jZmLg=
MIME-Version: 1.0
In-Reply-To: <tip-30246557a06bb20618bed906a06d1e1e0faa8bb4@git.kernel.org>
References: <tip-*@git.kernel.org>
	<tip-30246557a06bb20618bed906a06d1e1e0faa8bb4@git.kernel.org>
Date: Thu, 12 Aug 2010 14:15:23 +0200
X-Google-Sender-Auth: JWasU7j8wtRjm8AeqBXTR7bRNO8
Message-ID: <AANLkTimoKzp17CXZhuRSSRH=FMqPyJjtvpBkSG8-8ZHN@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, asm: Refactor atomic64_386_32.S to support
 old binutils and be cleaner
From: Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luca@luca-barbieri.com, kd6lvw+software@kd6lvw.ampr.org,
        tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any reason you applied the older version I attached to the bug,
instead of the second one?

NiTr0 reported an additional issue with this version you committed,
which is solved by the second patch I attached.
