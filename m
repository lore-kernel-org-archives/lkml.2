Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab1DAPTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:19:38 -0400
Received: from ra.se.axis.com ([195.60.68.13]:55517 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab1DAPTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:19:37 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Apr 2011 11:19:36 EDT
Date: Fri, 1 Apr 2011 17:11:36 +0200 (CEST)
From: Ricard Wanderlof <ricard.wanderlof@axis.com>
X-X-Sender: ricardw@lnxricardw.se.axis.com
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] do not select KALLSYMS_ALL
In-Reply-To: <1301670104.2789.94.camel@localhost>
Message-ID: <Pine.LNX.4.64.1104011710460.18181@lnxricardw.se.axis.com>
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
 <4D948D52.4040708@grupopie.com>  <1301669776.2789.92.camel@localhost>
 <1301670104.2789.94.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 Apr 2011, Artem Bityutskiy wrote:

> > On Fri, 2011-04-01 at 17:56 +0300, Artem Bityutskiy wrote:
> > Well, ok, I've measured how much is this "a lot". On an embedded arm
> > platform this makes the kernel only 1.5% larger. 
>
> But in absolute numbers this is 70KiB in my case, which is indeed
> considerable amount. So, I agree that it makes sense to keep this as a
> separate option.

Yes there are platforms where space is tight and 70 KiB could make or 
break a given setup.

/Ricard
-- 
Ricard Wolf Wanderlöf                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
