Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1KZAnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 19:43:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46874 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab1KZAnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 19:43:40 -0500
Date: Sat, 26 Nov 2011 04:43:35 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org,
        mad_soft@inbox.ru, koen@dominion.thruhere.net
Subject: Re: [PATCH] power/ds2760_battery: Add rated capacity of the hx4700
 3600mAh battery
Message-ID: <20111126004335.GA1703@oksana.dev.rtsoft.ru>
References: <CA+gwMcf9xvcFNJoxmDO0z-FMhKrd=9eptSDrpsBB3a20pzMfKw@mail.gmail.com>
 <1322178776.45812.YahooMailClassic@web29011.mail.ird.yahoo.com>
 <20111125235613.GA21434@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111125235613.GA21434@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 03:56:13AM +0400, Anton Vorontsov wrote:
[...]
> The only thing we can do is some machine-specific fixup. The
> universal way is ds2760_battery.rate_capacity module (and kernel
> command line) parameter that you can use to fixup the value.

Oh, btw, nowadays there is support for writable properties in the
power supply class. So, in addition to the module parameter, for
convenience you might also implement write-function for the
rated_capacity value.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
