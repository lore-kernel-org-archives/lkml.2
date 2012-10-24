Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab2JXUo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:44:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:31186 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab2JXUo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:44:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,642,1344236400"; 
   d="scan'208";a="208740304"
Date: Wed, 24 Oct 2012 13:44:26 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/10] thp: implement refcounting for huge zero page
Message-ID: <20121024204426.GX2095@tassilo.jf.intel.com>
References: <20121018235941.GA32397@shutemov.name>
 <20121023063532.GA15870@shutemov.name>
 <20121022234349.27f33f62.akpm@linux-foundation.org>
 <20121023070018.GA18381@otc-wbsnb-06>
 <20121023155915.7d5ef9d1.akpm@linux-foundation.org>
 <20121023233801.GA21591@shutemov.name>
 <20121024122253.5ecea992.akpm@linux-foundation.org>
 <20121024194552.GA24460@otc-wbsnb-06>
 <20121024132552.5f9a5f5b.akpm@linux-foundation.org>
 <20121024203329.GA24716@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024203329.GA24716@otc-wbsnb-06>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andrea Revieved-by previous version of the patchset, but I've dropped the
> tag after rebase to v3.7-rc1 due not-so-trivial conflicts. Patches 2, 3,
> 4, 7, 10 had conflicts. Mostly due new MMU notifiers interface.

I reviewed it too, but I probably do not count as a real MM person.

-Andi
