Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1DFMQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:16:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63828 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1DFMQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RNag/T9nhte7c8Exqq5OS/N2i4HZbby/c1OvuTyP26AwHJl/kuw7cxAn7STQkKONC0
         Fnu2VyxXbDaGwkYK9KopGPDrmoLvyEaOmFI+eAKAucK9ZbC08LkjfWluzKs0F4r5UGlq
         ZtZHXvetFmZgHuEzGte1KFq2K4K1DQTiIhmB0=
Date: Wed, 6 Apr 2011 16:16:35 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [RFC PATCH 2/7] basic_mmio_gpio: convert to
 platform_{get,set}_drvdata()
Message-ID: <20110406121635.GA13850@oksana.dev.rtsoft.ru>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
 <1302088263-12714-3-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302088263-12714-3-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 12:10:58PM +0100, Jamie Iles wrote:
> Use the platform drvdata helpers rather than working on the struct
> device itself.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
