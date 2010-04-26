Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab0DZJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:29:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41784 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab0DZJ3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:29:24 -0400
Subject: RE: [RFC PATCH 0/5] HSI framework and drivers
From: Carlos Chinea <carlos.chinea@nokia.com>
To: "Vehmanen Kai (Nokia-D/Tampere)" <Kai.Vehmanen@nokia.com>
Cc: ext Paul Walmsley <paul@pwsan.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "s-jan@ti.com" <s-jan@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
In-Reply-To: <725063E4C37388418CDDC5A2C287906A16B778D24E@NOK-EUMSG-03.mgdnok.nokia.com>
References: <1272035728-6933-1-git-send-email-carlos.chinea@nokia.com>
	 <alpine.DEB.2.00.1004231001190.29720@utopia.booyaka.com>
	 <725063E4C37388418CDDC5A2C287906A16B778D24E@NOK-EUMSG-03.mgdnok.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 12:32:20 +0300
Message-Id: <1272274340.17338.83.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Apr 2010 09:29:18.0691 (UTC) FILETIME=[F219DB30:01CAE522]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 21:44 +0200, Vehmanen Kai (Nokia-D/Tampere) wrote:
> Hi Paul and others,
> 
> On 23 April 2010, Paul Walmsley wrote:
> >> SSI, which is a legacy version of HSI, is used to connect the application
> >> engine with the cellular modem on the Nokia N900.
> >>
> >> This patch set is based on 2.6.34-rc3
> >
> >Have you looked at Sébastien's HSI driver code:
> >
> >http://www.mail-archive.com/linux-omap@vger.kernel.org/msg18506.html
> 
> I think the history of the patches is already shared. I've been 
> looking at this from the sidelines and I think the story so 
> far is:
> 
> 2008: Carlos sent the original SSI patchset (and got comments)
>    -> http://lkml.org/lkml/2008/10/3/116
> 2009: Sébastien sent an updated patchset (and got comments)
>    -> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg18506.html
> 
> .. and now this latest one from Carlos is a completely new
> design that attempts to address the design comments that have
> been raised, hopefully pushing HSI/SSI a step closer to 
> getting accepted. I'll leave it to Carlos and Sébastien to 
> correct me if I got the above wrong...

Yep you got it right. Sébastien and I have been also in contact about
the new API and he has already given some feedback on an initial version
of the framework.

Br,
Carlos

