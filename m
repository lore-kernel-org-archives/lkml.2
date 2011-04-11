Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1DKMGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:06:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35226 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1DKMGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e6bCz69LhaE6sutrI4gTGe2Oei+IAkTekh9wUfgwHAgtnom9sx3dP6iDKr71hXs8Q3
         j/QirfqsDIabRz3z3darV/6L9+TgWtvs0wMMa/AueerrmnjLZUA50g07h2cofPXddmOk
         k5TueSor/ySshQ6hJEjZJ3oIQmNelDMEkzaUg=
Date: Mon, 11 Apr 2011 16:06:07 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv3 6/7] basic_mmio_gpio: support different input/output
 registers
Message-ID: <20110411120607.GB1906@oksana.dev.rtsoft.ru>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <1302520914-22816-7-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302520914-22816-7-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 12:21:53PM +0100, Jamie Iles wrote:
> Some controllers have separate input and output registers.  For these
> controllers, use "set" for the output and "dat" for the input.
> 
> Changes since v2: reuse "set" for output and "dat" for input rather than
> adding a new "in" register.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
