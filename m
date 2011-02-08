Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1BHSBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:01:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52202 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1BHSBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OxTiRuJj1qgeCjxe9xXajIDM7MF6AZoxe/aAcqtQ1bDWh10qF68Uvk7hflwfj90CT8
         hMuXCr7/66TrTMX5Mq9Q9pZ2wLaO3U46pCYMBzsWgo/sjVkdRWsOAO2dVPwPGpijeZ0e
         FfudvLquju9oWnECcd3K6aYWw8u4sOmusgYwg=
MIME-Version: 1.0
In-Reply-To: <AANLkTint8uzHC2ELFRgaopZpqwo9oXa4Yy8xcQfBCW9r@mail.gmail.com>
References: <AANLkTinLOSfdO0HVABANiBnKgN540fc0pzqhjDAKAa2B@mail.gmail.com>
	<AANLkTin-RGqvUDT-GOBQkP2Rn6+2w7AWarSKHseLSORc@mail.gmail.com>
	<AANLkTint8uzHC2ELFRgaopZpqwo9oXa4Yy8xcQfBCW9r@mail.gmail.com>
Date: Tue, 8 Feb 2011 10:01:52 -0800
Message-ID: <AANLkTi=uK2sHmzLwBM_ZGi+=AgM6cZLO9k_nNi88Arax@mail.gmail.com>
Subject: Re: Regarding Buddy Allocator
From: Dave Hylands <dhylands@gmail.com>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Mulyadi Santosa <mulyadi.santosa@gmail.com>,
        Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sri,

On Tue, Feb 8, 2011 at 9:33 AM, Sri Ram Vemulpali
<sri.ram.gmu06@gmail.com> wrote:
> Thanks Santosa, Not much is mentioned in the link you mentioned.
>
> I looking for more of explanation and optimal implementation. Any
> reference would be good too.

Googling for buddy allocator seems to come up with several good links,
including at least one with an implementation
<http://lmgtfy.com/?q=buddy+allocator>

Dave Hylands
