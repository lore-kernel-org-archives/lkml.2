Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab2EYNZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:25:28 -0400
Received: from mail.southpole.se ([193.12.106.18]:46641 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2EYNZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:25:27 -0400
Message-ID: <1337952325.3557.61.camel@jerome.southpole.se>
Subject: Re: [PATCH] OpenRISC: Make do_signal() non-static
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Fri, 25 May 2012 15:25:25 +0200
In-Reply-To: <1337426347-3557-1-git-send-email-richard@nod.at>
References: <1337426347-3557-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 52324-13959
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks, applied.
/Jonas

On Sat, 2012-05-19 at 13:19 +0200, Richard Weinberger wrote:
> There is no need to export this function.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/openrisc/kernel/signal.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
> index 44749d4..f0446ec 100644
> --- a/arch/openrisc/kernel/signal.c
> +++ b/arch/openrisc/kernel/signal.c
> @@ -284,7 +284,7 @@ handle_signal(unsigned long sig,
>   * mode below.
>   */
>  
> -void do_signal(struct pt_regs *regs)
> +static void do_signal(struct pt_regs *regs)
>  {
>  	siginfo_t info;
>  	int signr;


