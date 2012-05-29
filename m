Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab2E2QOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:14:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57882 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754062Ab2E2QOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:14:49 -0400
Message-ID: <1338308088.2202.39.camel@joe2Laptop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, John Stultz <john.stultz@linaro.org>
Date: Tue, 29 May 2012 09:14:48 -0700
In-Reply-To: <1338307620.886.21.camel@mop>
References: <1336004953.4240.9.camel@mop> <20120526111143.GA32304@lizard>
	 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
	 <1338307620.886.21.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 18:07 +0200, Kay Sievers wrote:
[]
> --- a/include/linux/kmsg_dump.h
> +++ b/include/linux/kmsg_dump.h
[]
> @@ -56,6 +69,18 @@ static inline void kmsg_dump(enum kmsg_d
>  {
>  }
>  
> +bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
> +			  const char *line, size_t size, size_t *len)
> +{
> +	return false
> +}

uncompilable.



