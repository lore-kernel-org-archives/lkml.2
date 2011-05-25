Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1EYD0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:26:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60820 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1EYD0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oDRIhfdND4fj8AUiTeXW43Q/XR9Bey7i7ovGUenTeKD37BPvMCsAhOL/Dsvi/Fxu3U
         XLPTTP9hLFrMG2u70M9Edq/ipcdma1WTQWTGZLi3aeZ/3gjVdlJo5eJURcFixA3Du1Xt
         080429fngH++ozTVfRd3u30n9bFtKoaTJ/vX4=
Subject: Re: TCP session management
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nauman Tahir <nauman.tahir@gmail.com>
Cc: Kernel Newbies <kernelnewbies@nl.linux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTinMJZq_Wkf41Q-MRn4uC17hEsKUqQ@mail.gmail.com>
References: <BANLkTinMJZq_Wkf41Q-MRn4uC17hEsKUqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 05:26:18 +0200
Message-ID: <1306293978.3305.14.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 mai 2011 à 15:29 -0700, Nauman Tahir a écrit :
> Hi
> 
> I am interested in learning about highly practiced/recommended
> algorithms used for TCP session management in the stack. I am writing
> code for an embedded processor which needs to process TCP/IP flows and
> it does not have the stack. I am interested in implementing most
> efficient algorithm to maintain/lookup about 5 million full duplex TCP
> sessions.

Hi

Not sure what are your needs...

Linux has no particular problems handling 5 million councurrent tcp
sessions, granted you have enough memory.

What do you mean by "it does not have the stack" ?



