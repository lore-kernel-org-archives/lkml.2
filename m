Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1CWSK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:10:29 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58749 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab1CWSK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:10:27 -0400
Date: Wed, 23 Mar 2011 14:10:18 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: unused variables cleanup in check_eofblocks_fl
 and ext4_ext_map_blocks
Message-ID: <20110323181018.GA2548@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110322115126.GB5086@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322115126.GB5086@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 01:51:26PM +0200, Sergey Senozhatsky wrote:
> ext4 extents cleanup:
> 
>   . remove unused `*ex' from check_eofblocks_fl
>   . remove unused `*eh' from ext4_ext_map_blocks
> 
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Added to the ext4 patch queue, thanks.

				- Ted
