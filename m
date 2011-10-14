Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1JNPrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:47:52 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57734 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1JNPru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:47:50 -0400
Date: Fri, 14 Oct 2011 11:47:25 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: dave@jikos.cz, Hugo Mills <hugo-lkml@carfax.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, Chris Mason <chris.mason@oracle.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: A Plumber???s Wish List for Linux
Message-ID: <20111014154725.GB13119@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>, dave@jikos.cz,
	Hugo Mills <hugo-lkml@carfax.org.uk>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	lennart@poettering.net, harald@redhat.com, david@fubar.dk,
	greg@kroah.com, Chris Mason <chris.mason@oracle.com>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <1317943022.1095.25.camel@mop>
 <20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
 <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
 <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
 <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
 <20111007152137.GE28351@carfax.org.uk>
 <20111010111813.GF17912@twin.jikos.cz>
 <4C18E3B8-FA7E-4BC1-BE5D-B517004321A2@mit.edu>
 <20111013002839.GL3159@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013002839.GL3159@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 11:28:39AM +1100, Dave Chinner wrote:
> Yup. xfs_admin already provides an interface for offline
> modification of the UUID for XFS filesytems. I.e. clone the
> filesytem using xfs_copy, then run xfs_admin -U generate <clone> to
> generate a new uuid in the cloned copy before you mount the
> clone....

This is probably another thing which perhaps Ric Wheeler's proposed
"generic LVM / file system management front end" should abstract away,
since every single file system has a different way of setting the UUID
in an off-line way.  It's a relatively specialized feature, so I
wouldn't call it high priority to implement first.

	      	      	       	  - Ted
