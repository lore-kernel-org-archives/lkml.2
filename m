Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0IASgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 14:36:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55959 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab0IASgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 14:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CAu45HX3rb/BZmNGqYI3OwhfOJUk3gb4rJfwSN1krtzv4Jk7OJzA2mPZZ1Wyb2BAQR
         ZR+9V+p6zHHroRTSrsWhPMRSkN5amTljHJ/7clXy9fGM5wdRjI6nfhJVlDqQnHTdfsWn
         I7lzG7o4ovqgxZd18pg0u0Kwa9faFDZYlylLI=
Date: Wed, 1 Sep 2010 22:36:02 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>, Julia Lawall <julia@diku.dk>,
        Wolfson Patches <patches@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wm831x_power: Removed duplicate mask from wm831x power
 driver
Message-ID: <20100901183602.GA30667@oksana.dev.rtsoft.ru>
References: <1283360967.1831.239.camel@Tapajos>
 <20100901172552.GD22444@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100901172552.GD22444@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 06:25:52PM +0100, Mark Brown wrote:
> On Wed, Sep 01, 2010 at 06:09:27PM +0100, Ian Lartey wrote:
> > Reported-by: Julia Lawall <julia@diku.dk>
> > Signed-off-by: Ian Lartey <ian@opensource.wolfsonmicro.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thanks.
