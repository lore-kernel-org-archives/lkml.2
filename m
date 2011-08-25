Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab1HYNvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:51:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab1HYNvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:51:05 -0400
Date: Thu, 25 Aug 2011 15:51:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2011-08-24-14-08 uploaded
Message-ID: <20110825135103.GA6431@tiehlicka.suse.cz>
References: <201108242148.p7OLm1lt009191@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108242148.p7OLm1lt009191@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed 24-08-11 14:09:05, Andrew Morton wrote:
> The mm-of-the-moment snapshot 2011-08-24-14-08 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

I have just downloaded your tree and cannot quilt it up. I am getting:
[...]
patching file tools/power/cpupower/debug/x86_64/centrino-decode.c
Hunk #1 FAILED at 1.
File tools/power/cpupower/debug/x86_64/centrino-decode.c is not empty after patch, as expected
1 out of 1 hunk FAILED -- rejects in file tools/power/cpupower/debug/x86_64/centrino-decode.c
patching file tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
Hunk #1 FAILED at 1.
File tools/power/cpupower/debug/x86_64/powernow-k8-decode.c is not empty after patch, as expected
1 out of 1 hunk FAILED -- rejects in file tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
[...]
patching file virt/kvm/iommu.c
Patch linux-next.patch does not apply (enforce with -f)

Is this a patch (I am using 2.6.1) issue? The failing hunk looks as
follows:
--- a/tools/power/cpupower/debug/x86_64/centrino-decode.c
+++ /dev/null
@@ -1 +0,0 @@
-../i386/centrino-decode.c
\ No newline at end of file

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
