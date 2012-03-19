Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2CSEvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 00:51:41 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43670 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab2CSEvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 00:51:39 -0400
Date: Mon, 19 Mar 2012 00:51:41 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] ext4: Rename ext4_warning to ext4_warn and
 ext4_error to ext4_err
Message-ID: <20120319045141.GP31682@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1331856299.git.joe@perches.com>
 <63e631fd75c084fa0f40d41f8f935cab2b46948d.1331856300.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63e631fd75c084fa0f40d41f8f935cab2b46948d.1331856300.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 05:07:37PM -0700, Joe Perches wrote:
> Make the logging macros more like the current kernel logging style.
> 
> Neaten the macro definitions.
> Align arguments and 80 column wrapping.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Code churn.  NACK.

					- Ted
