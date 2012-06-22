Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2FVO3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:29:44 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:53350 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab2FVO3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:29:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20452.32826.165122.958868@quad.stoffel.home>
Date: Fri, 22 Jun 2012 10:24:58 -0400
From: "John Stoffel" <john@stoffel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        peterz@infradead.org, minchan@gmail.com, kosaki.motohiro@gmail.com,
        andi@firstfloor.org, hannes@cmpxchg.org, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 00/11] mm: scalable and unified arch_get_unmapped_area
In-Reply-To: <1340315835-28571-1-git-send-email-riel@surriel.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Rik" == Rik van Riel <riel@surriel.com> writes:

Rik> A long time ago, we decided to limit the number of VMAs per
Rik> process to 64k. As it turns out, there actually are programs
Rik> using tens of thousands of VMAs.


Rik> Performance

Rik> Testing performance with a benchmark that allocates tens
Rik> of thousands of VMAs, unmaps them and mmaps them some more
Rik> in a loop, shows promising results.

How are the numbers for applications which only map a few VMAs?  Is
there any impact there?

John
