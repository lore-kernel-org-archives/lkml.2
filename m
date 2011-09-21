Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1IULyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 07:54:07 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:37522 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1IULyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 07:54:06 -0400
Date: Wed, 21 Sep 2011 07:57:30 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Suresh Jayaraman <sjayaraman@suse.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: 3.1-rc4: CIFS VFS: Received no data, expecting 4
Message-ID: <20110921075730.74c3b512@corrin.poochiereds.net>
In-Reply-To: <4E79C958.7080702@suse.com>
References: <alpine.DEB.2.02.1109181258480.8689@p34.internal.lan>
	<4E79C958.7080702@suse.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011 16:54:08 +0530
Suresh Jayaraman <sjayaraman@suse.com> wrote:

> Adding linux-cifs@vger.kernel.org to Cc.
> 
> On 09/18/2011 10:29 PM, Justin Piszcz wrote:
> > Hello,
> > 
> > What does this mean and why does it occur?
> 
> This error seems to occur when we try to read from a socket and actually
> read no data. Not sure when this would occur.
> 

It would be nice to know what was returned by kernel_recvmsg here. Was
it "0" or an error code of some kind?

> > (mounted a Windows 7 share)
> > 
> > [ 1090.606501] CIFS VFS: Received no data, expecting 4
> > [ 1120.575675] CIFS VFS: Received no data, expecting 4
> > [ 1150.544783] CIFS VFS: Received no data, expecting 4
> > [ 1180.513925] CIFS VFS: Received no data, expecting 4
> > [ 1210.483044] CIFS VFS: Received no data, expecting 4
> > [ 1240.452187] CIFS VFS: Received no data, expecting 4
> > [ 1270.421345] CIFS VFS: Received no data, expecting 4
> > [ 1300.390432] CIFS VFS: Received no data, expecting 4
> > [ 1330.359595] CIFS VFS: Received no data, expecting 4
> > [ 1360.328755] CIFS VFS: Received no data, expecting 4
> > [ 1390.283901] CIFS VFS: Received no data, expecting 4
> > [ 1420.249492] CIFS VFS: Received no data, expecting 4
> > [ 1450.218690] CIFS VFS: Received no data, expecting 4
> > [ 1480.187842] CIFS VFS: Received no data, expecting 4
> > [ 1510.156925] CIFS VFS: Received no data, expecting 4
> > [ 1540.126080] CIFS VFS: Received no data, expecting 4
> > [ 1570.095264] CIFS VFS: Received no data, expecting 4
> > [ 1600.064381] CIFS VFS: Received no data, expecting 4
> > [ 1630.033567] CIFS VFS: Received no data, expecting 4
> > [ 1660.002595] CIFS VFS: Received no data, expecting 4
> > [ 1689.971796] CIFS VFS: Received no data, expecting 4
> > [ 1719.940916] CIFS VFS: Received no data, expecting 4
> > [ 1749.910064] CIFS VFS: Received no data, expecting 4
> > [ 1779.879160] CIFS VFS: Received no data, expecting 4
> > [ 1809.848347] CIFS VFS: Received no data, expecting 4
> > [ 1839.817414] CIFS VFS: Received no data, expecting 4
> > [ 1869.786612] CIFS VFS: Received no data, expecting 4
> > [ 1899.755742] CIFS VFS: Received no data, expecting 4
> > [ 1929.724890] CIFS VFS: Received no data, expecting 4
> > [ 1959.694018] CIFS VFS: Received no data, expecting 4
> > [ 1989.663177] CIFS VFS: Received no data, expecting 4
> > [ 2019.632306] CIFS VFS: Received no data, expecting 4
> > [ 2049.601480] CIFS VFS: Received no data, expecting 4
> > 
> > Justin.
> > 
> 
> -Suresh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton@poochiereds.net>
