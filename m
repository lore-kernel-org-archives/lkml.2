Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1GRTF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:05:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46238 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab1GRTFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:05:55 -0400
MIME-Version: 1.0
In-Reply-To: <1309563076-5050-2-git-send-email-lacombar@gmail.com>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
	<1309563076-5050-2-git-send-email-lacombar@gmail.com>
Date: Mon, 18 Jul 2011 15:05:53 -0400
Message-ID: <CACqU3MU1kFzn9916A8vq+jB+r=4iDmWp_kk=E+thPuojWwZA6g@mail.gmail.com>
Subject: Re: [RFC 1/4] kbuild: export MAKECMDGOALS
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 1, 2011 at 7:31 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Cc: Steven Rostedt <srostedt@redhat.com>
> ---
>  Makefile |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index afb8e0d..ea517fd 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -22,6 +22,9 @@ LC_COLLATE=C
>  LC_NUMERIC=C
>  export LC_COLLATE LC_NUMERIC
>
> +# Export make goals
> +export MAKECMDGOALS
> +
>  # We are using a recursive build, so we need to do a little thinking
>  # to get the ordering right.
>  #
Michal, before I send a new version of this serie, can you tell me
your point of view on the export of MAKECMDGOALS (or
KBUILD_MAKECMDGOALS) and Kconfig to the environment ?

Thanks,
 - Arnaud
