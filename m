Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0KKRw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:52:28 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48391 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab0KKRw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:52:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RoRLNZwfQe+OdJeapo0uvwe3Nm5+qbDAfX/ZMnif0TGfzMpG/FbRPSD6+ou/+/LZkk
         SjEo7U53VUKjSwllQi+03B7NJ+gicG1/8X7ADhSRAiPWJt38hsQk/5CtAa/PPhZptS/C
         TlH3n/cyeQ/jcyeJZzlB6ZE7sdpSvS9ONVhjE=
Date: Thu, 11 Nov 2010 20:52:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Subject: Re: [PATCH UPDATED 3/9] x86: Make
	default_send_IPI_mask_sequence/allbutself_logical() 32bit only
Message-ID: <20101111175222.GB6517@lenovo>
References: <1289473363-29440-1-git-send-email-tj@kernel.org> <1289473363-29440-4-git-send-email-tj@kernel.org> <4CDC2914.5060403@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDC2914.5060403@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 06:34:12PM +0100, Tejun Heo wrote:
> Both functions are used only in 32bit.  Put them inside CONFIG_X86_32.
> This is to prepare for logical apicid handling update.
> 
> - Cyrill Gorcunov spotted that I forgot to move declarations in ipi.h
>   under CONFIG_X86_32.  Fixed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> ---

yup, thanks Tejun,
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
