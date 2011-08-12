Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1HLP7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:59:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1HLP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:59:42 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=eisdwKgMlAkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=4DpGv-UzhSiCBayho-cA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 04/10] ktest: Introduce RESET_TIME
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Jones <drjones@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1313155932-20092-5-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
	 <1313155932-20092-5-git-send-email-drjones@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Aug 2011 11:59:39 -0400
Message-ID: <1313164779.18583.327.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,


On Fri, 2011-08-12 at 15:32 +0200, Andrew Jones wrote:
 
> +# If the console needs to be reset during a reboot cycle in
> +# order to reestablish it's connection, then set this option
> +# to the number of seconds ktest should wait between disconnect
> +# and reconnect. This is needed when using 'virsh console' to
> +# connect to guests.
> +# (default undefined)
> +#RESET_TIME = 5

I think the name RESET_TIME is a bit ambiguous. Maybe it should be
called CONSOLE_RESET_TIME.

-- Steve

> +
>  # Reboot the target box on error (default 0)
>  #REBOOT_ON_ERROR = 0
>  


