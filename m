Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0KISqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:46:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63438 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab0KISqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:46:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VqcJPORR5Pf1a7avPcdR9WBwFYnlnbT/DrPZ52yoDW2/Kzf2S0bVq5F2dt1uPAEEok
         DpA1sXAjK8uKFACoN/ChO6dc8lNKswiIEXwQt9FWlLbW9x4WbGMXpgDAsnsVR5ntQcZp
         nRxMhlFRoQGMnbYO3a9NIRCqBDiOZ1jIBkDmU=
MIME-Version: 1.0
In-Reply-To: <20101109181434.GF5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
	<20101109181434.GF5876@outflux.net>
Date: Tue, 9 Nov 2010 20:46:42 +0200
X-Google-Sender-Auth: UfCfs5hE-6Ylj2Fwanr6Y9Ekg54
Message-ID: <AANLkTi=BiYsoMJzzphh=ddpq=jkAMafnB0WdRkMXsd8L@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86: rename verify_cpu_64.S to verify_cpu.S
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 8:14 PM, Kees Cook <kees.cook@canonical.com> wrote:
> This file does not need the _64 extension since the code is 32bit already,
> and can be used in 32bit routines.
>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  arch/x86/boot/compressed/head_64.S |    2 +-
>  arch/x86/kernel/trampoline_64.S    |    2 +-
>  arch/x86/kernel/verify_cpu.S       |  106 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/verify_cpu_64.S    |  106 ------------------------------------
>  4 files changed, 108 insertions(+), 108 deletions(-)
>  create mode 100644 arch/x86/kernel/verify_cpu.S
>  delete mode 100644 arch/x86/kernel/verify_cpu_64.S

Please use "git format-patch -M" to detect renames when preparing patches.
