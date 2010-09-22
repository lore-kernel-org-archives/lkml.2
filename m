Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0IVKOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:14:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42231 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0IVKOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GNlv9ce5J6wDGiYPCjnzEZ3FUaCl+B8KXzZqPqbd0nzf4JfwDs7l/PkgjW5eOBCuNJ
         iqGapClRB1SiHcfR8Kjwwc9E8OCMblzWre3skWiYMqNNrq1vlApD7CN9b5HCJ11FEa1q
         wQ/CtVjGzmkjW03rTW65Yz40HGal1MpbuLyEE=
Date: Wed, 22 Sep 2010 12:14:21 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: John Stultz <johnstul@us.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Stephan Gatzka <stephan@gatzka.org>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Message-ID: <20100922101421.GA3337@riccoc20.at.omicron.at>
References: <AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>
 <20100817085324.GB3330@riccoc20.at.omicron.at>
 <1282090963.1734.97.camel@localhost>
 <20100818071942.GA4096@riccoc20.at.omicron.at>
 <1282176776.2865.100.camel@localhost.localdomain>
 <20100819055518.GA4084@riccoc20.at.omicron.at>
 <1282594125.3111.344.camel@localhost.localdomain>
 <20100827123849.GC11657@riccoc20.at.omicron.at>
 <1282948239.2268.155.camel@jstultz-laptop>
 <AANLkTinRM3_kBc5S3wV=_S6P8+x7A43kz0qSYbixJYnq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinRM3_kBc5S3wV=_S6P8+x7A43kz0qSYbixJYnq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 04:47:45PM -0400, Kyle Moffett wrote:
> Well how about something much more straightforward:

I am about to post another patch set for discussion, so please comment
on it when it appears.

Thanks,
Richard
