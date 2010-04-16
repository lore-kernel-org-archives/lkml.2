Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0DPPPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:15:18 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35905 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab0DPPPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p7WTZQCoCFdhAAEe8DO+QeCpZLCyx7eH/YuHKxfjyYgecnsuxMsqGDzKXfsjN+1/FM
         +SYwK7fcbuRqu8diZndDkKiwklfjTnWURCS8lWSkWxEdXC2JsazRMrQrlvuTPFqDyAgM
         JZc43zCpZWK6zbNfo8U5rfO1BslQpWfWO3WS4=
Date: Fri, 16 Apr 2010 19:15:10 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] pda_power: add function callbacks for suspend and
 resume
Message-ID: <20100416151510.GA29249@oksana.dev.rtsoft.ru>
References: <1271108002-15574-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1271108002-15574-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 11:33:22PM +0200, Daniel Mack wrote:
> Add function prototypes for power management events so they can be
> handled and used by platform implementations.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> ---

Applied, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
