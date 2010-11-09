Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0KITJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:09:21 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64812 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0KITJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:09:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bmH6jZBOpyyejjwGNWi7txPoWmpb2AyMUOi9zogrRk85CH3K9CLWJoG5cKH4NzU94P
         ut5GS2z4xdyEhGG3IA5uDhYtwQB0yUEgD4zb08/DlNXF83CGohO9bnIB3eLw0A54lXIu
         wEAEHBXIhUDfGWb7i2zwOUDd2Zlt3I9vl31Gk=
MIME-Version: 1.0
In-Reply-To: <20101109181525.GH5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
	<20101109181525.GH5876@outflux.net>
Date: Tue, 9 Nov 2010 21:09:18 +0200
X-Google-Sender-Auth: dZIZ9JbL6E63sqAE2XFnDH8d8bY
Message-ID: <AANLkTimzAaj1Z-jyCLBPKGzp_PWw2hwkYy_XeLo8CKPP@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 8:15 PM, Kees Cook <kees.cook@canonical.com> wrote:
> The XD_DISABLE-clearing side-effect needs to happen on 32bit CPU
> start-up as well.
>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

The patch description here is pretty damn terse. Why do we need the
clearing for? Does not clearing XD_DISABLE cause some problem?
