Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab2EaNh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:37:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55520 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137Ab2EaNhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:37:25 -0400
Date: Thu, 31 May 2012 15:37:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mroos@linux.ee,
        JBottomley@parallels.com
Subject: Re: [PATCH v2 0/4] fix / cleanup async scsi scanning
Message-ID: <20120531133720.GA21281@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	mroos@linux.ee, JBottomley@parallels.com
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
 <20120530182239.GD15635@x1.osrc.amd.com>
 <CABE8wwsw98KZS0W1sJghzrei0mSGLiMoh+7Wn5xOzdM54qiYqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABE8wwsw98KZS0W1sJghzrei0mSGLiMoh+7Wn5xOzdM54qiYqA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:29:23AM -0700, Dan Williams wrote:
> They're ready for a run, but are likely 3.6 material.  For 3.5 I think
> James is going with the smaller fix posted here:
> 
> http://marc.info/?l=linux-scsi&m=133796775807498&w=2

Yep,

both the smaller fix and the 4-patch set cure the box here, thanks.

Tested-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
Boris.
