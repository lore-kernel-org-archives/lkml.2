Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0KZRpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:45:42 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57090 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0KZRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:45:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nZOpIu9oi0DsRE/5jpm+uqXPVCqb+N7ZLyXuf5GIH8etjnSp1B7K7mqtNmtRpzo0r5
         2R4bT0c9j+/3liCZLegwUgZMGRgqjjxFMkUtv4zIB8CFvkLsFV+Jn8Xk1wvB2VDh6BOf
         9bsItT6q+JWypul5nwbqz6QKYbb8f/d2JCxkM=
Date: Fri, 26 Nov 2010 20:45:33 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: kernel-janitors@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Magnus Damm <damm@opensource.se>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: boards: mach-se: use IS_ERR() instead of NULL check
Message-ID: <20101126174533.GA29507@albatros>
References: <1290791190-21358-1-git-send-email-segoon@openwall.com>
 <Pine.LNX.4.64.1011261835500.16655@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1011261835500.16655@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Fri, Nov 26, 2010 at 18:38 +0100, Guennadi Liakhovetski wrote:
> On Fri, 26 Nov 2010, Vasiliy Kulikov wrote:
> > clk_get() returns ERR_PTR() on error, not NULL.
> > 
> > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> 
> Yep, there are, probably, a couple more of these, similar to

I found a bit more, but I'd like to get feedback on these or just see it
applied first ;)


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
