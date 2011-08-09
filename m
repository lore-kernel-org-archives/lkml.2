Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab1HIUwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 16:52:38 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:59784 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab1HIUwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 16:52:37 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=3CAT4r-dEVgA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=tlf1A0flXDu0pkJXk_AA:9 a=lZzpJhahoEhUmEKPbaQA:7 a=CjuIK1q_8ugA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux@horizon.com>, <linux-kernel@vger.kernel.org>
References: <4E40C55F.8070703@systemfabricworks.com> <OFBF50514E.82734B36-ONC12578E7.005E58EE-C12578E7.005F648F@transmode.se>
In-Reply-To: <OFBF50514E.82734B36-ONC12578E7.005E58EE-C12578E7.005F648F@transmode.se>
Subject: RE: [patch v3 6/7] crc32: add-slicing-by-8.diff
Date: Tue, 9 Aug 2011 15:52:34 -0500
Message-ID: <018501cc56d6$448293a0$cd87bae0$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQF1xyKC3NFpBDSpQjvmEwcz73CzIwFHH570lbfkt+A=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >    - extend largest BITS size from 32 to 64
> >    - extend table from tab[4][256] to tab[8][256]
> >    - change algorithm to align on 8 byte boundary
> >      (it was noted that all that is really required
> >      is that the inner loop must comsume 8 bytes.
> >      As written it can start on even or odd 4 byte
> >      boundary.)
> So why not do that in the code too?
> 

I did the experiment with the random test set and it is a couple of % faster
so I made the change. I had thought that it wouldn't make a measurable
difference.

