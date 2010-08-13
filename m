Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173Ab0HMKwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:52:50 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59956 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934140Ab0HMKwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:52:49 -0400
Date: Fri, 13 Aug 2010 06:48:06 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, nhorman@redhat.com,
        kexec@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, akpm@linux-foundation.org,
        Vivek Goyal <vgoyal@redhat.com>,
        huang ying <huang.ying.caritas@gmail.com>, ebiederm@xmission.com
Subject: Re: [Resend][Patch v2] kexec: increase max of kexec segments and use
 dynamic allocation
Message-ID: <20100813104806.GA6077@hmsreliant.think-freely.org>
References: <20100813054314.5564.21503.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813054314.5564.21503.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 01:38:54AM -0400, Amerigo Wang wrote:
> 
> Currently KEXEC_SEGMENT_MAX is only 16 which is too small for machine with
> many memory ranges.  When hibernate on a machine with disjoint memory we do
> need one segment for each memory region. Increase this hard limit to 16K
> which is reasonably large.
> 
> And change ->segment from a static array to a dynamically allocated memory.
> 
> Cc: Neil Horman <nhorman@redhat.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: huang ying <huang.ying.caritas@gmail.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
Concur with Simon

Reviewed-by: Neil Horman <nhorman@tuxdriver.com>

