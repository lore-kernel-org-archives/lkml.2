Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0KPSQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:16:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44493 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab0KPSQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pdCDqyB4tCaPIdfW91eWkN1Asb87OIgpfZ+4fcRRA6c3ee7I/MG0F5wQAOSjdCja6S
         YiEJRK5vf16OMxPfETUgXhUpNYyt/jXshmdWR6VEeWTtBO+pCV9G5g1dU8O4/2f/jXxq
         p8YsMFHqIE01QwzyyK4YcxI/pV1KARBs6i6hc=
MIME-Version: 1.0
In-Reply-To: <1289931004-16066-1-git-send-email-kees.cook@canonical.com>
References: <1289931004-16066-1-git-send-email-kees.cook@canonical.com>
Date: Tue, 16 Nov 2010 20:16:26 +0200
X-Google-Sender-Auth: XGf3fCp4Vs9Q0eJT4IpYLwCMMao
Message-ID: <AANLkTi=QrVKkTcRGqxm+UgE-XoGwZ+6SjJ8LP-=i_PWe@mail.gmail.com>
Subject: Re: [PATCH] x86: fix included-by file reference comments
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 8:10 PM, Kees Cook <kees.cook@canonical.com> wrote:
> Adjust the paths for files that are including verify_cpu.S.
>
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
