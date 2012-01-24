Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2AXBIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 20:08:38 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:48739 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab2AXBIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 20:08:36 -0500
Date: Mon, 23 Jan 2012 20:06:02 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Roger Leigh <rleigh@codelibre.net>,
        Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
Subject: Re: /etc/fstab.d yes or not
Message-ID: <20120124010602.GA27017@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Roger Leigh <rleigh@codelibre.net>, Karel Zak <kzak@redhat.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	util-linux@vger.kernel.org
References: <20120120140444.GC13157@x2.net.home>
 <20120120154912.GK8797@codelibre.net>
 <CAPXgP13a9v+f1uNdpe-c+aApLfLpgn15b1-gZxRPd0wMvU=B-Q@mail.gmail.com>
 <20120120162220.GN8797@codelibre.net>
 <CAPXgP11pvch92n1=mMfDsMLoGZMG8xq0e1juXyUO6mxFR6_GYg@mail.gmail.com>
 <ACD4236E-A309-465F-8789-DA3A5B648313@mit.edu>
 <20120123220720.1b2e9663@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123220720.1b2e9663@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 10:07:20PM +0000, Alan Cox wrote:
> 
> So with a good coding hat on - please don't consider fstab API, it's got
> a programming interface 8). Otherwise I agree fstab.d is wrong.
> 

It has a programming interface for reading, but other programs can do
modify (and read) the file directly.  If some joker decided to change
the formatting of /etc/fstab from tab-delimeted to some crazy XML
encoding, I am certain things would break.

					- Ted
