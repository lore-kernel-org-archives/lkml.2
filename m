Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab3AGHKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:10:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49815 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3AGHJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:09:59 -0500
Date: Mon, 7 Jan 2013 10:09:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/power/88pm860x_battery.c: eliminate possible
 references to released resources
Message-ID: <20130107070935.GS7247@mwanda>
References: <1354986995-2324-1-git-send-email-Julia.Lawall@lip6.fr>
 <20130106050953.GH6919@lizard.sbx05280.losalca.wayport.net>
 <alpine.DEB.2.02.1301060941400.2070@localhost6.localdomain6>
 <20130106211649.GA26928@lizard.sbx05280.losalca.wayport.net>
 <20130107064223.GR7247@mwanda>
 <20130107065321.GA31407@lizard.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107065321.GA31407@lizard.gateway.2wire.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 10:53:21PM -0800, Anton Vorontsov wrote:
> On Mon, Jan 07, 2013 at 09:42:23AM +0300, Dan Carpenter wrote:
> > On Sun, Jan 06, 2013 at 01:16:50PM -0800, Anton Vorontsov wrote:
> > > The patch is whitespace-damaged (for some reason there are two spaces in
> > > the beginning of each non-change line). I repeated changes manually, but
> > > you might want to fix your mail/patch setup anyway. :)
> > > 
> > 
> > It may be something on your end, the patch applies fine for me.
> 
> I just looked into Julia's email headers, and it says:
> 
>   Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
> 
> flowed? for the patch? :) That's not right.
> 
> Documentation/email-clients.txt says:
> 
>   Don't send patches with "format=flowed".  This can cause unexpected
>   and unwanted line breaks.
> 
> :-P
> 
> As for why it applied fine for you, your mailer probably automatically
> decodes the content, but I apply mbox file directly. (If I '<ESC>-C' the
> email in mutt, then it also applies for me, but I normally don't do that.)

Ah.  You're right, of course.  I'm also using mutt but I have
<decode-copy> in my macros like you say.

macro index,pager ap "<shell-escape>rm -f tmp/patch<enter><decode-copy>tmp/patch<enter><shell-escape>~/progs/kernel/apply_patch.sh ~/var/mail/tmp/patch<enter>"

When I pipe to scripts it uses the undecoded copy.  I wish I knew
how to use the decoded version there as well...

regards,
dan carpenter

