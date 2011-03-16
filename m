Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab1CPBwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 21:52:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:39693 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1CPBwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 21:52:20 -0400
Subject: Re: [PATCH] scsi: use list_move() instead of list_del()/list_add()
 combination
From: James Bottomley <James.Bottomley@suse.de>
To: Robert Love <robert.w.love@intel.com>
Cc: kirill@shutemov.name, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, devel@open-fcoe.org
In-Reply-To: <20110315235710.16992.33761.stgit@localhost6.localdomain6>
References: <1300229605-14499-5-git-send-email-kirill@shutemov.name>
	 <20110315235710.16992.33761.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 21:52:09 -0400
Message-ID: <1300240329.13316.27.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 16:57 -0700, Robert Love wrote:
> From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> Cc: Robert Love <robert.w.love@intel.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: devel@open-fcoe.org

You can junk the cc's; they're mostly annotations for git-send-email

> Acked-by: Robert Love <robert.w.love@intel.com>

And this has to be Signed-off-by not Acked-by.  The reason is that
you've resent the patch (and altered it as you transmitted it) so that
makes you part of the signoff chain.  If you ack a patch, it means I can
pick it up from source and you as maintainer didn't actually touch it.

James


