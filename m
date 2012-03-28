Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab2C1Ate (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:49:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55407 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577Ab2C1Atd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:49:33 -0400
Date: Wed, 28 Mar 2012 02:49:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] mm/memory_failure: Let the compiler add the function name
Message-ID: <20120328004928.GU22197@one.firstfloor.org>
References: <1332843450-7100-1-git-send-email-bp@amd64.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332843450-7100-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fine for me. Andrew normally handles memory-failure.c patches these days.

-- 
ak@linux.intel.com -- Speaking for myself only.
