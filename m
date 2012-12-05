Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2LEVoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:44:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2LEVn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:43:57 -0500
Date: Wed, 5 Dec 2012 19:24:03 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, gleb@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] kvm: Move private memory slots to start of
 memslots array
Message-ID: <20121205212403.GC20260@amt.cnet>
References: <20121203231912.3661.57179.stgit@bling.home>
 <20121203233930.3661.7744.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203233930.3661.7744.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 04:39:30PM -0700, Alex Williamson wrote:
> In order to make the memslots array grow on demand, move the private
> slots to the lower indexes of the array.  The private slots are
> assumed likely to be in use, so if we didn't do this we'd end up
> allocating the full memslots array all the time.

You're changing private slot ids. Fail to see why is that relevant
to on-demand growing.

