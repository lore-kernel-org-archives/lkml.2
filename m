Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0DUXp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:45:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab0DUXpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:45:20 -0400
Date: Thu, 22 Apr 2010 02:51:18 +0300
From: Izik Eidus <ieidus@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] ksm: check for ERR_PTR from follow_page()
Message-ID: <20100422025118.360ea4bc@redhat.com>
In-Reply-To: <20100421102759.GA29647@bicker>
References: <20100421102759.GA29647@bicker>
Organization: redhat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010 12:27:59 +0200
Dan Carpenter <error27@gmail.com> wrote:

Hello

> The follow_page() function can potentially return -EFAULT so I added 
> checks for this.
> 
> Also I silenced an uninitialized variable warning on my version of gcc 
> (version 4.3.2).
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> I'm not very familiar with this code, so handle with care.


Acked-by: Izik Eidus <ieidus@redhat.com>

Thanks.
