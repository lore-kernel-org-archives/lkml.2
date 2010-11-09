Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0KITLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:11:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47345 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0KITLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:11:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=q5dq31dzNl6tsK7uhdK80Cp0a2E35eG+R/UB6s/7m2UVcoQtinusD9YpIo84RnipAb
         peqMWtmF3TE4RF9TrlvrD9s2O8OtLLdgE+Kf+wncknpgG1+h0FNjDNallnZUI7jS8E/G
         5/5wBC41JA5K50/cIqJqrlGs+DFeK8ZuqjKGo=
MIME-Version: 1.0
In-Reply-To: <20101109190205.GM5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
	<20101109181434.GF5876@outflux.net>
	<AANLkTi=BiYsoMJzzphh=ddpq=jkAMafnB0WdRkMXsd8L@mail.gmail.com>
	<20101109190205.GM5876@outflux.net>
Date: Tue, 9 Nov 2010 21:11:16 +0200
X-Google-Sender-Auth: q9iFeR0cPbBF3JhknLlkkI-BiGE
Message-ID: <AANLkTik-HDXBxj04T4tukC1-ufg3S5+2GRCL0g+Wwp_W@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86: rename verify_cpu_64.S to verify_cpu.S
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 9:02 PM, Kees Cook <kees.cook@canonical.com> wrote:
> Is there a ~/.gitconfig stanza that can be added to default to using -M
> always?

IIRC, setting "diff.renames" to "true" makes format-patch use "-M" by default.
