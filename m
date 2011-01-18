Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1ARJeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 04:34:13 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:40255 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab1ARJeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 04:34:11 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Paul Mundt'" <lethal@linux-sh.org>
Cc: <sfr@canb.auug.org.au>, "'Arnd Bergmann'" <arnd@arndb.de>,
        <gregkh@suse.de>, <jbarnes@virtuousgeek.org>,
        <dmitry.torokhov@gmail.com>, <dtor@mail.ru>, <rubini@cvml.unipv.it>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-next@vger.kernel.org>
References: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn> <20110118043323.GF2122@linux-sh.org> <01b501cbb6ef$3299f2a0$97cdd7e0$@mprc.pku.edu.cn> <20110118091032.GA18525@linux-sh.org>
In-Reply-To: <20110118091032.GA18525@linux-sh.org>
Subject: RE: Request for unicore32 architecture codes to merge into linux-next
Date: Tue, 18 Jan 2011 17:33:44 +0800
Message-ID: <01bf01cbb6f2$cdba4a70$692edf50$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQKvmpDs5qji3UzzcGj9LCTNHzRliwD+9+G3Agb64f8BNk04jZHsygIg
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-next-owner@vger.kernel.org [mailto:linux-next-owner@vger.kernel.org] On Behalf Of Paul Mundt
> Sent: Tuesday, January 18, 2011 5:11 PM
> To: Guan Xuetao
> Cc: sfr@canb.auug.org.au; 'Arnd Bergmann'; gregkh@suse.de; jbarnes@virtuousgeek.org; dmitry.torokhov@gmail.com; dtor@mail.ru;
> rubini@cvml.unipv.it; linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org; linux-fbdev@vger.kernel.org; linux-
> next@vger.kernel.org
> Subject: Re: Request for unicore32 architecture codes to merge into linux-next
> 
> On Tue, Jan 18, 2011 at 05:07:41PM +0800, Guan Xuetao wrote:
> > IMO, the whole architecture specific codes need to be merged first, and only some
> > necessary drivers are included under staging. Then, I could split the staging drivers
> > into corresponding mail-list, and then, additional drivers.
> > Otherwise, there are no architecture basic for drivers review.
> >
> That's of course fine so long as the driver changes are reasonably
> self-contained. The situation we want to avoid is that you end up with
> drivers that depend on some private infrastructure of API where not
> enough context is provided when the two are decoupled.
> 
> In any event, the architecture bits are the most self-contained and have
> had the most review of anything in this series of patches, so it probably
> makes sense to work on getting those bits integrated and then dealing
> with the rest incrementally.
Then, I should:
1. merge reviewed arch dir and reviewed drivers (for now, i8042)
2. submit staging drivers to review
Am I right?

Thanks.
Guan Xuetao

