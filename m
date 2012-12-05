Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2LEVn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:43:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab2LEVn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:43:57 -0500
Date: Wed, 5 Dec 2012 19:22:00 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, gleb@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] kvm: Merge id_to_index into memslots
Message-ID: <20121205212200.GB20260@amt.cnet>
References: <20121203231912.3661.57179.stgit@bling.home>
 <20121203233924.3661.81373.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203233924.3661.81373.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 04:39:24PM -0700, Alex Williamson wrote:
> This allows us to resize this structure and therefore the number of
> memslots as part of the RCU update.

Why is this necessary? "struct memslots" is updated, message above
conflicts with that.

If there is a reason, "id_to_index" becomes confusing.

