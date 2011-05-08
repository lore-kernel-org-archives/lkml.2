Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1EHOpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:45:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:28827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab1EHOpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:45:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,335,1301900400"; 
   d="scan'208";a="744074269"
From: Andi Kleen <andi@firstfloor.org>
To: Emil Langrock <emil.langrock@gmx.de>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: checkpatch "unclean" patches
References: <201105080955.27160.emil.langrock@gmx.de>
Date: Sun, 08 May 2011 07:45:24 -0700
In-Reply-To: <201105080955.27160.emil.langrock@gmx.de> (Emil Langrock's
	message of "Sun, 8 May 2011 09:55:26 +0200")
Message-ID: <m2wri1i73v.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emil Langrock <emil.langrock@gmx.de> writes:
>
> Should I fix my patches or should checkpatch.pl be fixed?

Since your patches are fine, checkpatch.pl should be fixed of course. I
generally ignore bogus messages.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
