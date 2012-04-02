Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2DBSmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:42:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58252 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab2DBSmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:42:07 -0400
Date: Mon, 2 Apr 2012 11:42:04 -0700
From: "Ted Ts'o" <tytso@mit.edu>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Subject: Re: [RFC PATCH v2 18/21] ext4: add support for read_iter and
 write_iter
Message-ID: <20120402184204.GE2880@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zach Brown <zab@zabbo.net>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
 <1333122228-13633-19-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333122228-13633-19-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 10:43:45AM -0500, Dave Kleikamp wrote:
> use the generic .read_iter and .write_iter functions

Potentially silly question --- why not use NULL pointer to mean
generic_file_read_iter and generic_file_write_iter?  Then you won't
have to patch a bunch of file systems to add the generic .read_iter
and .write_iter?

						- Ted
