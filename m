Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0KIT7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:59:09 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49922 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0KIT7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:59:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Uca8aHc/W6DDwAy6oSpMn0XivRlFhIZSzg6oMnBV9xj6Ji2s8L37ISSnd/B9lNtCso
         PtaLbnRoqFBHnCmCuFPkALeKp+kG18EFGXXmpAUnsvA+ECbiojtNlJ1cffKihdKsFf+V
         X9871hQ2dc4u7sD4ON8VxOM8Eqkt5wdqKluM0=
MIME-Version: 1.0
In-Reply-To: <20101109190028.GL5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
	<20101109181434.GF5876@outflux.net>
	<AANLkTi=BiYsoMJzzphh=ddpq=jkAMafnB0WdRkMXsd8L@mail.gmail.com>
	<20101109190028.GL5876@outflux.net>
Date: Tue, 9 Nov 2010 21:59:05 +0200
X-Google-Sender-Auth: xIaRvYOe4ADa9VflIZKbI6iNZds
Message-ID: <AANLkTikdu0uyGL92G6ZiQMciHov0+QLL3XX-V3oeJUOi@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86: rename verify_cpu_64.S to verify_cpu.S
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 9:00 PM, Kees Cook <kees.cook@canonical.com> wrote:
> The code is 32bit already, and can be used in 32bit routines.
>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
