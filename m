Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0KCHyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 03:54:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43315 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab0KCHyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C6iDL3hictvdlxe6708rcngJXpuzwzyerphqCdDXhHZys+kTREhYUwWDP/XGcDZEMf
         ohq2q2WCR7I7fsHn/WCtSnCjA0kwej1n0MEv3aUADa30A/iIwELjw1sRo0cKqK+8r14q
         SKLUHri0U118clXczdih6PKkyUkcuUdUBWWPw=
MIME-Version: 1.0
In-Reply-To: <4CCBDDC0.8040502@gmail.com>
References: <4CCBDDC0.8040502@gmail.com>
Date: Wed, 3 Nov 2010 08:54:36 +0100
Message-ID: <AANLkTim9VrvkW-k0O+AXx1=b8E2ZGD5QwY928LhXR_JQ@mail.gmail.com>
Subject: Re: [PATCH] archs: add Kconfig symbol for set memory ro feature
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, andi@firstfloor.org, Tim Bird <tim.bird@am.sony.com>,
        tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/30 Marco Stornelli <marco.stornelli@gmail.com>:
> From: Marco Stornelli <marco.stornelli@gmail.com>
>
> This patch adds a new Kconfig symbol to recognize which arch implements a couple of functions set_memory_ro/set_memory_rw. These functions sets/unsets read-only flag at page table entry level. Until now only x86
> has got these functions. Next target will be arm and powerpc.
>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

Any comments?

Marco
