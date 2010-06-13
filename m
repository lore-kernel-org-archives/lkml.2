Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0FML1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 07:27:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:36762 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0FML1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 07:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TG08GYGawjYeLPj6BphIx7Fxwy2L2wjpBml5O3+/CmnatMO+ENIMrWuHVcE3kyfDSO
         5Y34VtGKnXbnWHDBJdXYWJadW+5tib3Q+54LYpgLZVnJwaH4GAS0XOaHgZhZaLdtrlMg
         VIatv9JMCjAzbO9HWgLExTDARjDc1ofbOSWf4=
Subject: Re: [PATCH v2] MMC: fix all hangs related to mmc/sd card
 insert/removal during suspend/resume.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-mmc <linux-mmc@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>
In-Reply-To: <1276283995-10812-1-git-send-email-maximlevitsky@gmail.com>
References: <1276283791.8557.29.camel@maxim-laptop>
	 <1276283995-10812-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 14:27:29 +0300
Message-ID: <1276428449.16701.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 22:19 +0300, Maxim Levitsky wrote: 
> If you don't use CONFIG_MMC_UNSAFE_RESUME, card will now be removed
> in pm notified while userspace is still running.
> Thus it will be possible to sync it propely.
> 
> Card detect workqueue is now freezeable, therefore a card insert/removal event will
> wait till userspace is unfrozen.
> 
> Tested with and without CONFIG_MMC_UNSAFE_RESUME with suspend and hibernate.
And I say it is now well tested.
All attempts to hang the system failed.

Best regards,
Maxim Levitsky

