Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2FRPOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:14:19 -0400
Received: from shelob.surriel.com ([74.92.59.67]:42794 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2FRPOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:14:17 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, peterz@infradead.org,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hnaz@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        knoel@redhat.com, Rik van Riel <riel@surriel.com>,
        Rik van Riel <riel@redhat.com>
Subject: [[PATCH -mm] 3/6] Fix the x86-64 page colouring code to take pgoff into account and use that code as the basis for a generic page colouring code.
Date: Mon, 18 Jun 2012 10:20:44 -0400
Message-Id: <1340029247-6949-4-git-send-email-riel@surriel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340029247-6949-1-git-send-email-riel@surriel.com>
References: <1340029247-6949-1-git-send-email-riel@surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<<< No Message Collected >>>
