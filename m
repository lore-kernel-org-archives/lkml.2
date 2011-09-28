Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1I1N0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:26:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1I1N0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:26:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 06/24] C6X: early boot code
Date: Wed, 28 Sep 2011 15:26:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-7-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-7-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281526.07969.arnd@arndb.de>
X-Provags-ID: V02:K0:LlL3TgdPzTre5alyyyFIbkhqvSUAHLS79PoQo53xGx6
 5602ESEPG53s53UCXrnjBQ08gHD6zZq83LSrCw6NQ5rX7/VJcZ
 LrxINJJ0PwigJw5iT5t/S7KybYmiFMqQYSve7xWlsCSsY+xGYz
 P6xOGZ3ENiBgQYNezOyAYsYV9D0tShZGPTPRnGxZ+t1Fo8Xro5
 Sag13ZsE/QHFwYrRNm+KgxR20kLPLVGkURUz7a54V3eApF/EdD
 6K1JLrRly3ZZDggHDl7CwWWle0R4qJOAOT+vCBJY+6bz3d33bo
 S8O1lG289uIpeAGOOb0emd1+WQxL+o5bHUu4EFEXo8HqmDzx00
 Ajr7/pp2Q4gWmha6SD/c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:

> +int c6x_num_cores;
> +EXPORT_SYMBOL(c6x_num_cores);
> +
> +unsigned int c6x_silicon_rev;
> +EXPORT_SYMBOL(c6x_silicon_rev);
> +
> +/*
> + * Device status register. This holds information
> + * about device configuration needed by some drivers.
> + */
> +unsigned int c6x_devstat;
> +EXPORT_SYMBOL(c6x_devstat);

> +unsigned int ticks_per_ns_scaled;
> +EXPORT_SYMBOL(ticks_per_ns_scaled);
> +
> +unsigned int c6x_core_freq;
> +EXPORT_SYMBOL(c6x_core_freq);

These all look like they are used internally (maybe not
ticks_per_ns_scaled) so it would be more appropriate to make
them EXPORT_SYMBOL_GPL.

	Arnd
