Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068Ab0EEMMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:12:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:21655 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab0EEMMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:12:34 -0400
Subject: Re: [PATCHv2] MTD: Suppress warnings in inline_map_read()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <i2w347733d51005041306q4b1d9f0bzd2206805c96cbad2@mail.gmail.com>
References: <1270891582.4704.102.camel@macbook.infradead.org>
	 <e970485f0e9f4c9e1cb6e594a45dd11308683197@localhost.localdomain>
	 <1272354388.26036.4.camel@localhost> <1272978272.3702.5.camel@localhost>
	 <i2w347733d51005041306q4b1d9f0bzd2206805c96cbad2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 15:11:39 +0300
Message-ID: <1273061499.3702.178.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 12:12:05.0372 (UTC) FILETIME=[2D36DBC0:01CAEC4C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 13:06 -0700, Kevin Cernekee wrote:
> On Tue, May 4, 2010 at 6:04 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > /home/dedekind/git/l2-mtd-2.6/include/linux/mtd/map.h: In function 'inline_map_read':
> > /home/dedekind/git/l2-mtd-2.6/include/linux/mtd/map.h:390: error: implicit declaration of function 'BUG'
> 
> I did test my patch, but it didn't generate any warnings or errors on MIPS...
> 
> Could you please apply this patch and retry:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2010-May/029904.html
> 
> <linux/bug.h> should probably be added anyway since there are two
> other BUG statements in that file.

Pushed this patch and the '[PATCH] mtd: map.h: add missing bug.h
include' one back to l2-mtd-2.6 / dunno.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

