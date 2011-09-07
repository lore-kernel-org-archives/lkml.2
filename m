Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1IGQuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:50:12 -0400
Received: from gw1.transmode.se ([195.58.98.146]:49338 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab1IGQuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:50:09 -0400
In-Reply-To: <OF3D37A60B.7A33B855-ONC1257904.00276B5B-C1257904.002951AF@LocalDomain>
References: <20110831213729.395283830@systemfabricworks.com> <4E5EB608.3000905@systemfabricworks.com> <OF3D37A60B.7A33B855-ONC1257904.00276B5B-C1257904.002951AF@LocalDomain>
Subject: Re: [PATCH v6 08/10] crc32-add-slicing-by-8.diff
X-KeepSent: CE19A3DB:816B06DF-C1257904:002E9D19;
 type=4; name=$KeepSent
Cc: Bob Pearson <rpearson@systemfabricworks.com>, akpm@linux-foundation.org,
        fzago@systemfabricworks.com, George Spelvin <linux@horizon.com>,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFCE19A3DB.816B06DF-ONC1257904.002E9D19-C1257904.002EC071@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 7 Sep 2011 10:30:39 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 09/07/2011 10:30:39
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joakim Tjernlund/Transmode wrote on 2011/09/07 09:31:18:
> > +# if CRC_LE_BITS == 32
> >     rem_len = len & 3;
> > -   /* load data 32 bits wide, xor data 32 bits wide. */
> >     len = len >> 2;
> > +# else
> > +   rem_len = len & 7;
> > +   len = len >> 3;
>
> I still fail to see why this is needed. You still do 32 bit loads so this
> only makes the code uglier, harder to maintain and makes small unaligned crc bufs
> slower.

Sorry, misread this part. Ignore it.

 Jocke

