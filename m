Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1DFMcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:32:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64414 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1DFMcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Bpansh950rimTmfXs3hCrOjgbvIzlogLzN3iugA0Yq5VUDy2ulGyVKpodqR2e52tNU
         B4rnJlhnCL/6Zgu31KJJZC5uvMMwCsg5GU3be+I8WpYVJlW0ojcNNlpBxxgHrdn3mFWX
         yaQrr/rQNhkVxvOEb+aBDh0yNaW4WbPZG+/Go=
Date: Wed, 6 Apr 2011 16:32:12 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [RFC PATCH 4/7] basic_mmio_gpio: request register regions
Message-ID: <20110406123212.GA17040@oksana.dev.rtsoft.ru>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
 <1302088263-12714-5-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302088263-12714-5-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 12:11:00PM +0100, Jamie Iles wrote:
> Make sure that we get the register regions with request_mem_region()
> before ioremap() to make sure we have exclusive access.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
