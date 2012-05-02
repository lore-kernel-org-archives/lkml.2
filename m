Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab2EBDce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:32:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:14108 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758498Ab2EBDcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:32:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="135960477"
Message-ID: <4FA0AA88.5040900@intel.com>
Date: Wed, 02 May 2012 11:31:20 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: aarcange@redhat.com, riel@redhat.com, mgorman@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] THP: need is_vma_temporary_stack() when reference transparent_hugepage_enabled
References: <1335594795-30876-1-git-send-email-alex.shi@intel.com> <20120430160520.4c1cc05c.akpm@linux-foundation.org> <4FA0A743.2070904@intel.com>
In-Reply-To: <4FA0A743.2070904@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> Oh, yes. Since is_vma_temporay_stack is just used in rmap.c and huge_memory.c
> . is it better to move it to huge_mm.h?



If you still concern someone just want to use is_vma_temporay_stack
function. I have no better idea. and please drop this patch if so. :)


