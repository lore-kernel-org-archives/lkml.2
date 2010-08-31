Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0HaAoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:44:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55800 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab0HaAoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:44:17 -0400
MIME-Version: 1.0
Message-ID: <dbb9f012-c09a-438f-99d0-4fbc40428f58@default>
Date: Mon, 30 Aug 2010 17:40:42 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
        mfasheh@suse.com, Joel Becker <joel.becker@oracle.com>, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org,
        JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
        npiggin@kernel.dk, Dave Mccracken <dave.mccracken@oracle.com>,
        riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>,
        mel@csn.ul.ie, yinghan@google.com, gthelen@google.com
Subject: RE: [PATCH V4 3/8] Cleancache: core ops functions and configuration
References: <20100830223133.GA1272@ca-server1.us.oracle.com
 4C7C3521.7090403@goop.org>
In-Reply-To: <4C7C3521.7090403@goop.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#ifdef CONFIG_CLEANCACHE
> > +#define cleancache_enabled (cleancache_ops.init_fs)
> 
> Pointers can be used in a boolean context, but it would probably be
> cleaner to have this evaluate to a proper boolean type.  Also I'd
> probably go with an all-caps macro name rather than making it look like
> a variable.

OK, thanks, will fix.
 
> > +/* useful stats available in /sys/kernel/mm/cleancache */
> > +static unsigned long succ_gets;
> > +static unsigned long failed_gets;
> > +static unsigned long puts;
> > +static unsigned long flushes;
> 
> I'd probably give these very generic-sounding names some slightly
> unique
> prefix just to help out people looking at "nm" output or using ctags.
> 
> > +static int get_key(struct inode *inode, struct cleancache_filekey
> *key)
> 
> Ditto.

OK, will do.

Thanks for the feedback!
Dan
