Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1FNKHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:07:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922Ab1FNKHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:07:03 -0400
Date: Tue, 14 Jun 2011 12:06:55 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: thp: minor lock simplification in __khugepaged_exit
Message-ID: <20110614100655.GF6371@redhat.com>
References: <20110610233355.GO23047@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610233355.GO23047@sequoia.sous-sol.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 04:33:55PM -0700, Chris Wright wrote:
> The lock is released first thing in all three branches.  Simplify this
> by unconditionally releasing lock and remove else clause which was only
> there to be sure lock was released.
> 
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>

Acked-by: Johannes Weiner <jweiner@redhat.com>
