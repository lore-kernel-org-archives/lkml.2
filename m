Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0JDUbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:31:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40345 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab0JDUbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:31:15 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=YGL2JzEyuHAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=l5qevOhvKpAuGNYZKA0A:9 a=wa6clQNjWDF--Wf6t5nZk_DxMAoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Dynamic nop selection breaks boot on Geode LX
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Daniel Drake <dsd@laptop.org>, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
In-Reply-To: <20101004154633.GA2900@redhat.com>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
	 <20101004154633.GA2900@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 04 Oct 2010 16:31:12 -0400
Message-ID: <1286224272.6750.70.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 11:46 -0400, Jason Baron wrote:

>  	restart_nmi();
> +
> +	local_irq_save(flags);
> +	arch_init_ideal_nop5();
> +	local_irq_restore(flags);
>  }
>  
>  /**

BTW, why the irq disabling around the call?

-- Steve


