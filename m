Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab0E1OPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:15:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44620 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab0E1OPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:15:37 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=h3IH-nlYCKgA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=XzXZbZvSaZF4n7_kF7MA:9 a=zN3ydxOvqo3jyGtVAs8A:7 a=vXinXzyVtZ3OaqvxMOtjx72bHMQA:4 a=PUjeQqilurYA:10 a=_RhRFcbxBZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] streamline_config.pl: make a variable local
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Toralf Foerster <toralf.foerster@gmx.de>
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <201005281025.00358.toralf.foerster@gmx.de>
References: <201005281025.00358.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 28 May 2010 10:15:35 -0400
Message-ID: <1275056135.22648.586.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 10:24 +0200, Toralf Foerster wrote:
> to prevent a possible pitfall
> 
> Signed-off-by: Toralf Foerster <toralf.foerster@gmx.de>
> ---
>  scripts/kconfig/streamline_config.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
> index afbd54a..9726946 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -307,7 +307,7 @@ close (LIN);
>  my %configs;
>  foreach my $module (keys(%modules)) {
>      if (defined($objects{$module})) {
> -       @arr = @{$objects{$module}};
> +       my @arr = @{$objects{$module}};


Either your mail client, or the method you use to get these into your
mail is causing whitespace issues. There are tabs here that your patch
has converted into spaces, causing the patch to fail to apply.

I've fixed it up, but please fix this before sending more patches.

-- Steve

>         foreach my $conf (@arr) {
>             $configs{$conf} = $module;
>         }
> -- 
> 1.6.4.4
> 
> 


