Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2ALUsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:48:36 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:47600 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab2ALUsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:48:32 -0500
Date: Thu, 12 Jan 2012 15:48:26 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
        Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <dchinner@redhat.com>,
        Surbhi Palande <csurbhi@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] Fix filesystem freezing
Message-ID: <20120112204826.GG6626@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326331253-6497-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 02:20:49AM +0100, Jan Kara wrote:
> reproduce deadlocks due to dirty data as well so please test these patches out.
> Thanks. Also review of patches is welcome.

This patch series looks good to me (modulo issues others have already
pointed out).

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

I assume you're going to send this up through Al's vfs tree?

  	 	      	      	      	      - Ted
