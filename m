Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab2F0OxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:53:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65045 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2F0OxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:53:20 -0400
MIME-Version: 1.0
In-Reply-To: <1340789620-15762-1-git-send-email-chad@dahc.us>
References: <1340789620-15762-1-git-send-email-chad@dahc.us>
Date: Wed, 27 Jun 2012 09:53:19 -0500
Message-ID: <CABqD9hZAiTcvsRBfaq+TekKf=pEJ4yPY=FwZ8V7Fxksjvw_F6A@mail.gmail.com>
Subject: Re: [PATCH] samples: seccomp: add .gitignore for untracked executables
From: Will Drewry <wad@chromium.org>
To: Chad Williamson <chad@dahc.us>
Cc: james.l.morris@oracle.com, keescook@chromium.org, eparis@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

Reviewed-By: Will Drewry <wad@chromium.org>

On Wed, Jun 27, 2012 at 4:33 AM, Chad Williamson <chad@dahc.us> wrote:
> git status should be clean following make allmodconfig && make. Add
> a .gitignore file to the samples/seccomp directory to ignore binaries
> produced there.
>
> Signed-off-by: Chad Williamson <chad@dahc.us>
> ---
>  samples/seccomp/.gitignore |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>  create mode 100644 samples/seccomp/.gitignore
>
> diff --git a/samples/seccomp/.gitignore b/samples/seccomp/.gitignore
> new file mode 100644
> index 0000000..78fb781
> --- /dev/null
> +++ b/samples/seccomp/.gitignore
> @@ -0,0 +1,3 @@
> +bpf-direct
> +bpf-fancy
> +dropper
> --
> 1.7.7
>
