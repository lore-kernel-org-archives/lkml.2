Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2AIJb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:31:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:38595 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2AIJb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:31:27 -0500
Message-ID: <1326101456.2442.40.camel@twins>
Subject: Re: [PATCH v6 0/8] Reduce cross CPU IPI interference
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 09 Jan 2012 10:30:56 +0100
In-Reply-To: <1326040026-7285-1-git-send-email-gilad@benyossef.com>
References: <y> <1326040026-7285-1-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-08 at 18:26 +0200, Gilad Ben-Yossef wrote:
> Still, kernel code will some time interrupt all CPUs in the system via IPIs
> for various needs. These IPIs are useful and cannot be avoided altogether,
> but in certain cases it is possible to interrupt only specific CPUs that
> have useful work to do and not the entire system. 

1-7

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


