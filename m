Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab2FMVe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:34:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50603 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2FMVe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:34:28 -0400
Message-ID: <1339623261.8980.65.camel@twins>
Subject: Re: [PATCH 2/4] x86: Track minimum microcode revision globally v2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 13 Jun 2012 23:34:21 +0200
In-Reply-To: <1339618842-26636-3-git-send-email-andi@firstfloor.org>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
	 <1339618842-26636-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 13:20 -0700, Andi Kleen wrote:
> +       for_each_online_cpu (i)

# git grep "for_each_[^(]*(" arch/x86/ | wc -l
315
# git grep "for_each_[^(]* (" arch/x86/ | wc -l
0

