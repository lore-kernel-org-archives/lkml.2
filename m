Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab0JEIQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:16:09 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53851 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0JEIQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:16:05 -0400
Date: Tue, 5 Oct 2010 17:16:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Robert Richter <robert.richter@amd.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 7/7] sh: Annotate oprofile_arch_exit() with __exit marker
Message-ID: <20101005081602.GD7984@linux-sh.org>
References: <cover.1286222593.git.matt@console-pimps.org> <4426d17460dc88dcb3d6e3af1b91af4db83785ae.1286222593.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4426d17460dc88dcb3d6e3af1b91af4db83785ae.1286222593.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 09:44:25PM +0100, Matt Fleming wrote:
> In order to avoid a section mismatch we need to annotate
> oprofile_arch_exit() with an __exit marker.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>

For general completeness:

Acked-by: Paul Mundt <lethal@linux-sh.org>
