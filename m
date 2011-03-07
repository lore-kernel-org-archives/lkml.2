Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1CGKaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:30:20 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58925 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1CGKaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:30:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Mj+E2D7JOTetKDFyRoA3SOcBsFkBMKkv1R5/oL7Yoorx0X6/LSXwFta8c2J62LrPd6
         hWcO2yWJrhwTWRfv7hHNsLN6/AMNSTte/DYzBnox14LY3OIlcg2p6W1IaYFqhzQGiirJ
         rylCzxCUaGfdRKM4VX4AqUTZAeK7dsKAyppYs=
Date: Mon, 7 Mar 2011 18:29:58 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: rdunlap@xenotime.net, linux-kernel@vger.kernel.org, linux@kbdbabel.org,
        romfs@googlegroups.com, linux-doc@vger.kernel.org,
        akpm@linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH]fix a link in Documentation/filesystem/romfs.txt
Message-ID: <20110307102956.GA2041@gmail.com>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>, rdunlap@xenotime.net,
	linux-kernel@vger.kernel.org, linux@kbdbabel.org,
	romfs@googlegroups.com, linux-doc@vger.kernel.org,
	akpm@linux-foundation.org, greg@kroah.com
References: <20110304115926.GA4104@gmail.com>
 <20110304093548.a37e0ef9.rdunlap@xenotime.net>
 <alpine.LNX.2.00.1103062207470.19969@pobox.suse.cz>
 <alpine.LNX.2.00.1103062211320.19969@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1103062211320.19969@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 10:12:23PM +0100, Jiri Kosina wrote:
> On Sun, 6 Mar 2011, Jiri Kosina wrote:
> 
> > > > Hello romfs group,
> > > > 	 I have posted a patch to fix the reference to
> > > > the outdated ftp site (which still serves genromfs-0.5.1) in
> > > > Documentation/filesystems/romfs.txt last month,
> > > > but nobody has picked it up yet.
> > > > 
> > > > Does anybody like to forward this?
> > > > Thanks, Alexander
> > > 
> > > Hi Jiri,
> > > Do you have this merged somewhere?
> > 
> > Hi Randy,
> > 
> > nope, I haven't been CCed and missed it on lkml (obviously :) ). Picked up 
> > now, thanks.
> 
> Ah, actually yes, it's already in the queue, commit ddf1228695.
Ok, thanks.

Best Regards.
Harry Wei.
> 
> -- 
> Jiri Kosina
> SUSE Labs, Novell Inc.
