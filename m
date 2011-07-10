Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1GJQe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:34:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36818 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1GJQe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:34:28 -0400
MIME-Version: 1.0
In-Reply-To: <1310306000-2447-1-git-send-email-brgerst@gmail.com>
References: <1310306000-2447-1-git-send-email-brgerst@gmail.com>
Date: Sun, 10 Jul 2011 19:34:27 +0300
X-Google-Sender-Auth: uUzIY0fdsTiMVnvvMAX-pzkvPyg
Message-ID: <CAOJsxLFqov_YeLOunJRuXcbsSC+w4deFSGAcA0jwjUYqU5SHLQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86-64: Simplify cpu_has_invlpg
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 4:53 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Define CONFIG_X86_INVLPG for 64-bit too, which simplifies the code.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
