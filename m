Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab2FULVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:21:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:48212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042Ab2FULU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:20:56 -0400
Message-ID: <1340277624.21745.173.camel@twins>
Subject: Re: [PATCH -mm 4/7] mm: make page colouring code generic
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Date: Thu, 21 Jun 2012 13:20:24 +0200
In-Reply-To: <1340057126-31143-5-git-send-email-riel@redhat.com>
References: <1340057126-31143-1-git-send-email-riel@redhat.com>
	 <1340057126-31143-5-git-send-email-riel@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 18:05 -0400, Rik van Riel wrote:
> Fix the x86-64 page colouring code to take pgoff into account.

Shouldn't that be a separate patch?
