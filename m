Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1CPVAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:00:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:24804 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab1CPVAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:00:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,195,1299484800"; 
   d="scan'208";a="720928461"
Subject: Re: [PATCH] scsi: use list_move() instead of list_del()/list_add()
 combination
From: Robert Love <robert.w.love@intel.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: "kirill@shutemov.name" <kirill@shutemov.name>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "devel@open-fcoe.org" <devel@open-fcoe.org>
In-Reply-To: <1300240329.13316.27.camel@mulgrave.site>
References: <1300229605-14499-5-git-send-email-kirill@shutemov.name>
	 <20110315235710.16992.33761.stgit@localhost6.localdomain6>
	 <1300240329.13316.27.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 14:00:45 -0700
Message-ID: <1300309245.19083.399.camel@fritz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 18:52 -0700, James Bottomley wrote:
> On Tue, 2011-03-15 at 16:57 -0700, Robert Love wrote:
> > From: Kirill A. Shutemov <kirill@shutemov.name>
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> > Cc: Robert Love <robert.w.love@intel.com>
> > Cc: linux-scsi@vger.kernel.org
> > Cc: devel@open-fcoe.org
> 
> You can junk the cc's; they're mostly annotations for git-send-email
> 
> > Acked-by: Robert Love <robert.w.love@intel.com>
> 
> And this has to be Signed-off-by not Acked-by.  The reason is that
> you've resent the patch (and altered it as you transmitted it) so that
> makes you part of the signoff chain.  If you ack a patch, it means I can
> pick it up from source and you as maintainer didn't actually touch it.
> 

Thanks for the clarification James.

Signed-off-by: Robert Love <robert.w.love@intel.com>

Let me know if you, or anyone else, wants me to resend the patch with
the Signed-off line.

//Rob

