Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab2JJRRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:17:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:16828 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2JJRR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:17:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,565,1344236400"; 
   d="scan'208";a="232319195"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, sqlite-users@sqlite.org,
        linux-fsdevel@vger.kernel.org, drh@hwaci.com
Subject: light weight write barriers
In-Reply-To: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	(Richard Hipp's message of "Wed, 10 Oct 2012 08:47:02 -0400")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Wed, 10 Oct 2012 10:17:23 -0700
Message-ID: <m2fw5mtffg.fsf_-_@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Hipp writes:
>
> We would really, really love to have some kind of write-barrier that is
> lighter than fsync().  If there is some method other than fsync() for
> forcing a write-barrier on Linux that we don't know about, please enlighten
> us.

Could you list the requirements of such a light weight barrier?
i.e. what would it need to do minimally, what's different from
fsync/fdatasync ?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
