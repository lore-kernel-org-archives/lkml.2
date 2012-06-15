Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab2FONxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 09:53:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39697 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2FONxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 09:53:43 -0400
Date: Fri, 15 Jun 2012 16:53:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Fengguang Wu <wfg@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Josh Triplett <josh@freedesktop.org>
Subject: Re: automated warning notifications
Message-ID: <20120615135319.GF4400@mwanda>
References: <20120614172523.GB4400@mwanda>
 <20120615014835.GA5695@localhost>
 <20120615071222.GZ13539@mwanda>
 <20120615075810.GA13206@localhost>
 <alpine.DEB.2.02.1206150639130.1864@hadrien>
 <20120615111913.GA13539@mwanda>
 <CA+MoWDrKJwiK66zpBxQ=q+qS7n_P4qLySgBRdj2txq20wa7bvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDrKJwiK66zpBxQ=q+qS7n_P4qLySgBRdj2txq20wa7bvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropped the Sparse people from the CC list.

On Fri, Jun 15, 2012 at 10:33:50AM -0300, Peter Senna Tschudin wrote:
> Added git-blame support...
> 

No.  I meant that it would run git blame on the offending line, take
the hash and then do a git show $hash.

regards,
dan carpenter

