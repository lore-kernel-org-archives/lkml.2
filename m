Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2JBPgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:36:14 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:61019
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545Ab2JBPgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:36:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,524,1344204000"; 
   d="scan'208";a="157610102"
Message-ID: <506B09DF.7010209@inria.fr>
Date: Tue, 02 Oct 2012 17:35:59 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v3 04/10] thp: do_huge_pmd_wp_page(): handle huge zero
 page
References: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com> <1349191172-28855-5-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1349191172-28855-5-git-send-email-kirill.shutemov@linux.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/10/2012 17:19, Kirill A. Shutemov a écrit :
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> On right access to huge zero page we alloc a new page and clear it.
>

s/right/write/ ?

Brice

