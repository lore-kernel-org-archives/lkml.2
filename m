Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab2FIR0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 13:26:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58286 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2FIR0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 13:26:33 -0400
Date: Sun, 10 Jun 2012 00:23:21 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: "Ted Ts'o" <tytso@mit.edu>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tao Ma <boyu.mt@taobao.com>
Subject: Re: [ 64/82] ext4: dont trash state flags in EXT4_IOC_SETFLAGS
Message-ID: <20120609152321.GC2215@kroah.com>
References: <20120607040345.775333506@linuxfoundation.org>
 <1339124589.21665.106.camel@deadeye.wl.decadent.org.uk>
 <20120608031144.GA9722@thunk.org>
 <1339125708.21665.108.camel@deadeye.wl.decadent.org.uk>
 <20120608200553.GA1704@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608200553.GA1704@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:05:53PM -0400, Ted Ts'o wrote:
> On Fri, Jun 08, 2012 at 04:21:48AM +0100, Ben Hutchings wrote:
> > 
> > It's not harmless because the user is no longer restricted to changing
> > EXT4_FL_USER_MODIFIABLE.
> 
> Um, very good point.  So we should either drop this commit and wait
> until the next stable release, or also pull commit b22b1f178f6 in as
> well.  Basically, this commit and b22b1f178f6 should appear in the
> same stable release.

Ok, I've queued that one up as well.

thanks,

greg k-h
