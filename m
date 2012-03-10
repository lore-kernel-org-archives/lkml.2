Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab2CJDwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 22:52:09 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:34479 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab2CJDwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 22:52:06 -0500
Date: Fri, 9 Mar 2012 22:52:02 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: getdents - ext4 vs btrfs performance
Message-ID: <20120310035202.GA5652@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Jacek Luczak <difrost.kernel@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jacek,

I'm curious parameters of the set of directories on your production
server.  On an ext4 file system, assuming you've copied the
directories over, what are the result of this command pipeline when
you are cd'ed into the top of the directory hierarchy of interest
(your svn tree, as I recall)?

find . -type d -ls | awk '{print $7}' | sort -n | uniq -c

I'm just curious what the distribution of directories sizes are in
practice for your use case...

Thanks,

						- Ted


