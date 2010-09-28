Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0I1WNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 18:13:16 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:42907 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0I1WNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 18:13:15 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
Date: Wed, 29 Sep 2010 00:13:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, janjaap@bos.nl,
        geert@linux-m68k.org, jaxboe@fusionio.com, martin.petersen@oracle.com,
        adobriyan@gmail.com, cdfrey@foursquare.net
References: <1285710456-4435-1-git-send-email-richard@nod.at> <20100928150000.f007f43e.akpm@linux-foundation.org>
In-Reply-To: <20100928150000.f007f43e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009290013.11332.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 29 September 2010, 00:00:00 schrieb Andrew Morton:
> This is a workaround, I think?  Do we know what the actual bug is?
> From the comment it appears to be a regression?

Yes, it is a workaround.
For more details please have a look at this post:
http://lkml.org/lkml/2010/9/28/245

Cheers,
//richard
