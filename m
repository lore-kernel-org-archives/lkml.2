Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0FMNSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 09:18:13 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:38757 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753499Ab0FMNSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 09:18:12 -0400
Message-ID: <4C14DA8F.9050109@example.com>
Date: Sun, 13 Jun 2010 15:18:07 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: dave.bueso@gmail.com
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] README: Add build speed up tip in BUILD section.
References: <1276434639.16577.6.camel@cowboy>
In-Reply-To: <1276434639.16577.6.camel@cowboy>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15749369373773164804
X-Ovh-Remote: 83.6.195.37 (abbf37.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.06.2010 15:10, Davidlohr Bueso wrote:
> Hi,
>
> IMHO the README file could benefit from GNU make's -j[N] option in BUILD section, as a general tip for users.
>
> Not entirely sure who deals with this file, so sending to Linus.
>
> Thanks.
>
> Signed-off-by: Davidlohr Bueso<dave@gnu.org>
> ---
>   README |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/README b/README
> index 737838f..fda7d52 100644
> --- a/README
> +++ b/README
> @@ -154,6 +154,11 @@ BUILD directory for the kernel:
>      Please note: If the 'O=output/dir' option is used then it must be
>      used for all invocations of make.
>
> +   Depending on the system and configuration, building the kernel can
> +   take some time. To speed things up you can use GNU make's -j[N] option
> +   to specify the number of jobs to run simultaneously. The N value should
> +   be twice the amount of the machine's CPUs.

I thought not CPUs but cores.

-- 
Janusz Korwin-Mikke:
"Idiota z dyplomem to taki sam idiota,
jak przedtem - tylko z pretensjami."
NP: Jeff Beck - Hip-Notica
NB: 2.6.35-rc3
