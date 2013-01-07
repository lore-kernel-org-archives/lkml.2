Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3AGGmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 01:42:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48245 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3AGGmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 01:42:49 -0500
Date: Mon, 7 Jan 2013 09:42:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/power/88pm860x_battery.c: eliminate possible
 references to released resources
Message-ID: <20130107064223.GR7247@mwanda>
References: <1354986995-2324-1-git-send-email-Julia.Lawall@lip6.fr>
 <20130106050953.GH6919@lizard.sbx05280.losalca.wayport.net>
 <alpine.DEB.2.02.1301060941400.2070@localhost6.localdomain6>
 <20130106211649.GA26928@lizard.sbx05280.losalca.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130106211649.GA26928@lizard.sbx05280.losalca.wayport.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 01:16:50PM -0800, Anton Vorontsov wrote:
> The patch is whitespace-damaged (for some reason there are two spaces in
> the beginning of each non-change line). I repeated changes manually, but
> you might want to fix your mail/patch setup anyway. :)
> 

It may be something on your end, the patch applies fine for me.

regards,
dan carpenter

