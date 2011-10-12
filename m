Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab1JLDJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 23:09:26 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60000 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab1JLDJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 23:09:25 -0400
Date: Tue, 11 Oct 2011 23:09:22 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca
Subject: Re: [PATCH] ext4/xattr_security.c: local functions should be static
Message-ID: <20111012030922.GD11548@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	H Hartley Sweeten <hartleys@visionengravers.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
References: <201109231538.22933.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109231538.22933.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 03:38:22PM -0700, H Hartley Sweeten wrote:
> Quiets the sparse noise:
> 
> warning: symbol 'ext4_initxattrs' was not declared. Should it be static?

What version of the kernel was this from?  I can't find
ext4_initxattrs in any kernel version that I can find in git...

		       	      	      	     - Ted
