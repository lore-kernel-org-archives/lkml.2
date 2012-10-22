Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2JVSxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:53:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33256 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab2JVSxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:53:35 -0400
MIME-Version: 1.0
In-Reply-To: <1350459589-55210-1-git-send-email-hare@suse.de>
References: <1350459589-55210-1-git-send-email-hare@suse.de>
Date: Mon, 22 Oct 2012 11:53:33 -0700
X-Google-Sender-Auth: _Fh-UQkQPYzTyM2IgN2-Q9RAujc
Message-ID: <CAGXu5jJ+tUt0+q0Mt8YPexVPesZW+eV64rypDia+NJDneR8_Qw@mail.gmail.com>
Subject: Re: [PATCH] ramoops: Fixup section annotations
From: Kees Cook <keescook@chromium.org>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 12:39 AM, Hannes Reinecke <hare@suse.de> wrote:
> The compiler complained about missing section annotations.
> Fix it.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Colin Cross <ccross@android.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tony Luck <tony.luck@intel.com>

Acked-by: Kees Cook <keescook@chromium.org>

Thanks for the fix!

-Kees

-- 
Kees Cook
Chrome OS Security
