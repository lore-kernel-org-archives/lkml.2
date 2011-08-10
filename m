Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1HJJdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:33:04 -0400
Received: from gw1.transmode.se ([195.58.98.146]:33318 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab1HJJdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:33:01 -0400
In-Reply-To: <018501cc56d6$448293a0$cd87bae0$@systemfabricworks.com>
References: <4E40C55F.8070703@systemfabricworks.com> <OFBF50514E.82734B36-ONC12578E7.005E58EE-C12578E7.005F648F@transmode.se> <018501cc56d6$448293a0$cd87bae0$@systemfabricworks.com>
Subject: RE: [patch v3 6/7] crc32: add-slicing-by-8.diff
X-KeepSent: 177C3D3E:3BACC024-C12578E8:00345039;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com, linux@horizon.com,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF177C3D3E.3BACC024-ONC12578E8.00345039-C12578E8.003474EE@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 10 Aug 2011 11:32:58 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/10/2011 11:32:58
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/09 22:52:34:

> From: "Bob Pearson" <rpearson@systemfabricworks.com>
> To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
> Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>, <linux@horizon.com>, <linux-kernel@vger.kernel.org>
> Date: 2011/08/09 22:52
> Subject: RE: [patch v3 6/7] crc32: add-slicing-by-8.diff
>
> > >    - extend largest BITS size from 32 to 64
> > >    - extend table from tab[4][256] to tab[8][256]
> > >    - change algorithm to align on 8 byte boundary
> > >      (it was noted that all that is really required
> > >      is that the inner loop must comsume 8 bytes.
> > >      As written it can start on even or odd 4 byte
> > >      boundary.)
> > So why not do that in the code too?
> >
>
> I did the experiment with the random test set and it is a couple of % faster
> so I made the change. I had thought that it wouldn't make a measurable
> difference.

That could depend on how the test data table is aligned. What if you change
the alignment of the table?

