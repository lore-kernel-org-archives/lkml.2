Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab0F3UEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:04:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:17231 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab0F3UEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nS27efYzLmKd6guCr2TJqPMdGaheIu6UUGzoKOGehvTbW4Ix6vJCr2XFwQQXXpd7Oq
         rcp25Tav28VSFvBa/9Nn9aaOrLMK7T6IFIh/QMRtOBa/Db4L42oveWg+eI+DDIqcMDB2
         oiHfSKrpvNhY59H5rOqKs97Y8Aj3Pdxi0GzGw=
Date: Thu, 1 Jul 2010 00:04:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: fix CFI coverage for error_entry()
Message-ID: <20100630200401.GA21058@lenovo>
References: <4C2B62880200007800008D59@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2B62880200007800008D59@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 02:28:08PM +0100, Jan Beulich wrote:
> The scope should really extend to the end of the function, not the
> return location.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>

Great catch, thanks Jan!
 
	-- Cyrill
