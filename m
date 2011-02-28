Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1B1VL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:11:58 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:50801 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab1B1VL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:11:56 -0500
Date: Mon, 28 Feb 2011 16:11:45 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: sfrench@us.ibm.com, agruen@linbit.com, dilger.kernel@dilger.ca,
        sandeen@redhat.com, bfields@fieldses.org, jlayton@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V5 00/24]  New ACL format for better NFSv4 acl
 interoperability
Message-ID: <20110228211145.GG28617@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	sfrench@us.ibm.com, agruen@linbit.com, dilger.kernel@dilger.ca,
	sandeen@redhat.com, bfields@fieldses.org, jlayton@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1298469131-16555-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298469131-16555-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aneesh,

What is the current status of this patch series?  I seem to remember
that Christoph and Al Viro had some objections; have those been
cleared yet?  If not, can you summarize what their objections are?

To be honest I haven't been paying super close attention to this patch
series, and I'm curious what needs to happen with it one way or
another.

						- Ted
