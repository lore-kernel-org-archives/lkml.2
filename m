Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab1DKMFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:05:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35226 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1DKMFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ESdV6E/XuAgY0mOXHBbmd1X6shf/Zh3AasMnOOetbShatAM+ioUYk3VOe+66QXDM3O
         vBSxpRFw9r6kfukzjMxnRWzacGvZ6V3Pm5rHHsZWOtKti9+58o9FjDZn8LVX+reYa8R3
         3Dq2cptdW4JYTgP3RvGLod/l0wfW7EfbhYMZw=
Date: Mon, 11 Apr 2011 16:05:48 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv3 5/7] basic_mmio_gpio: detect output method at probe
 time
Message-ID: <20110411120548.GA1906@oksana.dev.rtsoft.ru>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <1302520914-22816-6-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302520914-22816-6-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 12:21:52PM +0100, Jamie Iles wrote:
> Rather than detecting the output method each time in the .set()
> callback, do it at probe time and set the appropriate callback.
> 
> Changes since v2: moved the reg_dat initialization into
> bgpio_setup_io().
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks Jamie!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
