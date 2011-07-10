Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1GJQf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:35:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63583 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab1GJQf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:35:26 -0400
MIME-Version: 1.0
In-Reply-To: <1310306000-2447-2-git-send-email-brgerst@gmail.com>
References: <1310306000-2447-1-git-send-email-brgerst@gmail.com>
	<1310306000-2447-2-git-send-email-brgerst@gmail.com>
Date: Sun, 10 Jul 2011 19:35:25 +0300
X-Google-Sender-Auth: 4SVE4aOAS5moqDYT2khydxj9jCY
Message-ID: <CAOJsxLFU6QiCGnVHheUDXODFL92eCYw3phbEjC-2cJ9+nCHr=w@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Simplify X86_CMPXCHG, CMPXCHG_LOCAL, and X86_XADD
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 4:53 PM, Brian Gerst <brgerst@gmail.com> wrote:
> X86_64 and M386 can never be both set, so reduce the conditional to !M386.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
