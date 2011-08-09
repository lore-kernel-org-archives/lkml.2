Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1HIGAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 02:00:23 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:45013 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247Ab1HIGAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 02:00:22 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=HT6dtu4BAvoA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=68eEZQRoAAAA:8 a=VwQbUJbxAAAA:8 a=azj6Gt-4AAAA:8 a=YORvzBCaAAAA:8 a=Z4Rwk6OoAAAA:8 a=Xwy4Mv9B1GU2u3q424AA:9 a=ouYT1mmPCnj_eb06MgIA:7 a=CjuIK1q_8ugA:10 a=7YLhZ6jOsBkA:10 a=eJ1lpvm07AkA:10 a=VV2__AUApEoA:10 a=jbrJJM5MRmoA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Randy Dunlap'" <rdunlap@xenotime.net>
Cc: <linux-kernel@vger.kernel.org>, <linux@horizon.com>,
        <joakim.tjernlund@transmode.se>, <fzago@systemfabricworks.com>,
        <akpm@linux-foundation.org>
References: <4E40C28F.6070006@systemfabricworks.com> <d8d606c9a7ca85a50ef008b7697c84bc.squirrel@xenotime.net>
In-Reply-To: <d8d606c9a7ca85a50ef008b7697c84bc.squirrel@xenotime.net>
Subject: RE: [patch v3 1/7] crc32: move-to-documentation.diff
Date: Tue, 9 Aug 2011 01:00:20 -0500
Message-ID: <00d301cc5659$9f6b01d0$de410570$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJgDYdWJWPVm51guZ3wD5O+awR5wgIgOs0zk9uWNBA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> Sent: Tuesday, August 09, 2011 12:24 AM
> To: Bob Pearson
> Cc: linux-kernel@vger.kernel.org; linux@horizon.com;
> joakim.tjernlund@transmode.se; fzago@systemfabricworks.com;
> rpearson@systemfabricworks.com; akpm@linux-foundation.org
> Subject: Re: [patch v3 1/7] crc32: move-to-documentation.diff
> 
> On Mon, August 8, 2011 10:15 pm, Bob Pearson wrote:
> > Moved a nice but long comment from lib/crc32.c to
> Documentation/crc32.txt
> > where it will more likely get read.
> >
> > Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
> >
> > ---
> >  Documentation/crc32.txt |  129
> > ++++++++++++++++++++++++++++++++++++++++++++++++
> >  lib/crc32.c             |  127
> > -----------------------------------------------
> >  2 files changed, 129 insertions(+), 127 deletions(-)
> 
> Please update Documentation/00-INDEX with this new
> file's entry.

On its way. Thanks

> 
> Thanks.
> 
> --
> ~Randy

