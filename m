Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935296Ab0HQSpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:45:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60284 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936643Ab0HQSps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:45:48 -0400
Date: Tue, 17 Aug 2010 20:45:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Chris Frey <cdfrey@foursquare.net>, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: compiler warnings in 2.6.35.2
Message-ID: <20100817184544.GA9486@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Anca Emanuel <anca.emanuel@gmail.com>,
	Chris Frey <cdfrey@foursquare.net>, linux-kernel@vger.kernel.org,
	hpa@zytor.com
References: <20100817021252.GA17647@foursquare.net>
 <20100817053456.GA32714@liondog.tnic>
 <20100817062801.GA24978@foursquare.net>
 <20100817063159.GC32714@liondog.tnic>
 <20100817155333.GA17624@foursquare.net>
 <20100817162052.GA12785@a1.tnic>
 <AANLkTi=WWmOc4UVUxp_5w43zbZhP5nBfcv6oMCYNyuKE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTi=WWmOc4UVUxp_5w43zbZhP5nBfcv6oMCYNyuKE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anca Emanuel <anca.emanuel@gmail.com>
Date: Tue, Aug 17, 2010 at 08:15:21PM +0300

> On Tue, Aug 17, 2010 at 7:20 PM, Borislav Petkov <bp@alien8.de> wrote:
> > So why do you want to stay with 3.x anyway?
> 
> Read this: http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc1-maverick/BUILD.LOG
> Search for warnings.
> I tried to complile myself (using ubuntu 10.10 with latest updates),
> but failed at some staging driver. After uncheked the staging drivers,
> still failure.
> I'm using kernel 2.6.36-rc1 from
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc1-maverick/

Can you please elaborate a bit more, what are you trying to show here?

-- 
Regards/Gruss,
    Boris.
