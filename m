Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0LUXWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:22:36 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:45600 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab0LUXWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:22:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tQoRnFMl2no+4xGdJg80fPouu7fOiqj5y8bFS1WTigkpVWADWRT8Sbo7sB1b3hQuY4
         i4+wiOfXZJht+/yi1N9wtzhhqDk40Gmbr/OY5IGznltdeHnwaUwdDJlCGNc+Mk41SJpO
         X1paQ9El6F4/UwwxWd/bGemtKK2XCgJIaebaw=
Date: Wed, 22 Dec 2010 02:22:30 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: rklein <rklein@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Chew <AChew@nvidia.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 1/1] power: bq20z75: Update return value of CURRENT NOW
Message-ID: <20101221232230.GA5417@oksana.dev.rtsoft.ru>
References: <1292374885.8731.3.camel@rklein-linux2>
 <20101215030455.GA17414@lixom.net>
 <1292892862.12618.1.camel@rklein-linux2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1292892862.12618.1.camel@rklein-linux2>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:54:22PM -0800, rklein wrote:
> On Tue, 2010-12-14 at 19:04 -0800, Olof Johansson wrote:
> > On Tue, Dec 14, 2010 at 05:01:25PM -0800, rklein wrote:
> > > The BQ20Z75 will return a negative value for current if the battery is
> > > discharging and a positive value if charging. This should always be
> > > exported
> > > as a positive number.
> > >
> > > Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> > 
> > Reviewed-by: Olof Johansson <olof@lixom.net>
> > 
> > -Olof
> 
> Anton, is this patch ok to get put in?

I'm not sure. Probably not. Why would you think that the current
should always be positive? For ds2760 it isn't, for example.
If some driver assumes always positive current, I think it should
be fixed instead.

If the battery is discharging, let it be negative. That's what
happens on wires anyway. :-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
