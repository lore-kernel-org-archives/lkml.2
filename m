Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920Ab0D3S32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:29:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37531 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557Ab0D3S3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=IJjVh4NH/fEulB4xYV9WD8XnBfR1mSQLZDOCrskGg8flyvIjgBT2DQRk8xVzMd94DD
         ciXbyiq+5wn+m0aKGM6k3TLnrmsotGUqR0a9mL1R9a7jaatG3o6lUJ5zbnKSYwOOI7DA
         b9b7+38lvnDpwD4hTaJsCFrIv/CGGDB7JdINo=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Date: Thu, 29 Apr 2010 11:25:13 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201004230806.13628.pedrogfrancisco@gmail.com> <201004282252.07424.pedrogfrancisco@gmail.com> <p2z19f34abd1004290017sd2379471q67917514161b1133@mail.gmail.com>
In-Reply-To: <p2z19f34abd1004290017sd2379471q67917514161b1133@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004291125.13671.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Quinta, 29 de Abril de 2010 08:17:00 Vegard Nossum escreveu:
> Most likely you need to disable "Optimize for size", under "General
> setup" in the main menu to make it appear. But it could also be one of
> the other dependencies; check the "Depends on" line of KMEMCHECK when
> you do the search.
> 
> 
> Vegard

It was "CONFIG_FUNCTION_TRACER" which was on; incidently, such dependency 
doesn't appear in the "Depends on" line, had to do a web search.

Will post the results tomorrow, unless there aren't any.

-- 
Pedro
