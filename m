Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0G0Nbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 09:31:45 -0400
Received: from THUNK.ORG ([69.25.196.29]:51112 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab0G0Nbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 09:31:43 -0400
Date: Tue, 27 Jul 2010 09:31:46 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, ext4: Fix potential memory leak in ext4_fill_super
Message-ID: <20100727133146.GA18966@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20100616153332.GA6751@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616153332.GA6751@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 07:33:32PM +0400, Cyrill Gorcunov wrote:
> Under heavy memory pressure we may hit out of memory
> situation and as result kstrdup'ed options will not be
> freed. Fix it.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thanks, I've added this to the ext4 tree.

						- Ted
