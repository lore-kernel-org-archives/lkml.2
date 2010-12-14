Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab0LNUjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:39:07 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:39349 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951Ab0LNUjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:39:02 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/35] writeback: increase min pause time on concurrent dirtiers
In-Reply-To: Your message of "Tue, 14 Dec 2010 21:24:15 +0100."
             <1292358255.13513.390.camel@laptop>
From: Valdis.Kletnieks@vt.edu
References: <20101213144646.341970461@intel.com> <20101213150328.284979629@intel.com> <15881.1292264611@localhost> <20101214065133.GA6940@localhost> <14658.1292352152@localhost> <1292352908.13513.376.camel@laptop> <20252.1292357637@localhost>
            <1292358255.13513.390.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1292359075_5019P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Dec 2010 15:37:55 -0500
Message-ID: <21373.1292359075@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4D07D5A4.019A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1292359075_5019P
Content-Type: text/plain; charset=us-ascii

On Tue, 14 Dec 2010 21:24:15 +0100, Peter Zijlstra said:

> You're confused. 10*HZ jiffies is always 10 seconds.

I must be misremembering times past, when HZ was settable
but a jiffie was always 1/100th of a second...  Senility has
finally set it. :)

--==_Exmh_1292359075_5019P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNB9WjcC3lWbTT17ARAj7+AJ9/OF4KRUBMv0x5wXfUMLmmedtWvACffjh3
SVZe9YHIxLX+IUkfoJ5o9ds=
=MxJx
-----END PGP SIGNATURE-----

--==_Exmh_1292359075_5019P--

