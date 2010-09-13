Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0IMNcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:32:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61248 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0IMNcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ami0E9Hp1aDrTuL53LB3vW+H+BqbZ5MrMCvDDkMg9viZOmYw76UJWjrhOC3P3szhCI
         wk8xcKS8eUerijxgxXz5GOFSv5tyN/TgW0AxwRCh1NRo63iNtFncdSThw8QZRkH+GlLl
         7XfZJ/EKuYxlYDn+kN+K7MHElrKENgaSwKzlE=
Date: Mon, 13 Sep 2010 17:32:08 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: kernel-janitors@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Paul Mundt <lethal@linux-sh.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: hvc: check for error case
Message-ID: <20100913133208.GA11032@albatros>
References: <1284317835-5086-1-git-send-email-segooon@gmail.com>
 <4C8E2355.60807@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8E2355.60807@tilera.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 09:12 -0400, Chris Metcalf wrote:
> Thanks, accepted into my tree (for the next merge window).  In practice all
> this means is in debug mode we'll get a warning from do_one_initcall()
> rather than silence, but you're right, it's technically better. :-)

Anyway it's better, if user sees warning in the dmesg, he/she might
response to this situation.


Best,
-- 
Vasiliy
