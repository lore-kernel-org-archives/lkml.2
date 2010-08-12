Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab0HLPS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:18:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38734 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab0HLPSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w18Y8CMpe1UDLMSDNwK+uR5zP+o6E29VGrC/4Kx2Z5MTvnkoF1eln+mWhQtCf3jzQR
         AN26wsArdqzMDdSBX3TF2YG8F7/+F/6B+vHftBuT/gYP3Ba5RZAml/T56vTaFNEhFSud
         oUKFmNErZsV741GT6wN4VxWX4EJw3gKJods+A=
MIME-Version: 1.0
In-Reply-To: <4C63FFB6.9080301@zytor.com>
References: <tip-*@git.kernel.org>
	<tip-30246557a06bb20618bed906a06d1e1e0faa8bb4@git.kernel.org>
	<AANLkTimoKzp17CXZhuRSSRH=FMqPyJjtvpBkSG8-8ZHN@mail.gmail.com>
	<4C63FFB6.9080301@zytor.com>
Date: Thu, 12 Aug 2010 17:18:23 +0200
X-Google-Sender-Auth: sXO-7JCQXyZv6KDR2khKTO1WbXk
Message-ID: <AANLkTi=Kk8VWEJ_V1Ei_CSGFN1d+4h3NtER3yu=WYdcd@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, asm: Refactor atomic64_386_32.S to support
 old binutils and be cleaner
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        kd6lvw+software@kd6lvw.ampr.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I already had the first version queued up (I forgot to push it to the
> public repository, however).  I'll just put in the incremental changes.

OK, thanks.
