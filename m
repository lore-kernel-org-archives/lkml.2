Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab1CPNmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:42:17 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51290 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1CPNmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=mkv48tTmYic8SnVjTYwQOqgl82KU/c6hbeJiZ0noW7hyDWoOXdEwEDWO7pJK0MEJ7b
         1ttg8IEHpuDTq/Ie0d9+tZNM7MummApcwxxOCUke3MMrqnc2vUSQaQOsXCrvyV3BFyy0
         org2XDs7INpgxxCxsnPs756jtrBCoJIj7OTm0=
Date: Wed, 16 Mar 2011 16:42:06 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] s3c_adc_battery: Fix method names when PM not set
Message-ID: <20110316134206.GA12394@oksana.dev.rtsoft.ru>
References: <201103142112.39392.heiko@sntech.de>
 <201103142338.40584.anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201103142338.40584.anarsoul@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 11:38:40PM +0200, Vasily Khoruzhick wrote:
> On Monday 14 March 2011 22:12:39 Heiko Stübner wrote:
> > From: Heiko Stuebner <heiko@sntech.de>
> > 
> > s3c_adc_battery declares wrong method names when CONFIG_PM is not set.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> Acked-by: Vasily Khoruzhick <anarsoul@gmail.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
