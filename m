Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab2IGV1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:27:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:12510 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2IGV1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:27:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,387,1344236400"; 
   d="scan'208";a="199137568"
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/10] vfs: getname/putname overhaul
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
Date: Fri, 07 Sep 2012 14:26:56 -0700
In-Reply-To: <1347025085-20285-1-git-send-email-jlayton@redhat.com> (Jeff
	Layton's message of "Fri, 7 Sep 2012 09:37:55 -0400")
Message-ID: <m2r4qd4j8f.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

> This patchset is a first pass at overhauling the getname/putname
> interface to use a struct. The idea here is to add a new getname_info
> struct that allow us to pass around some auxillary info along with
> the string that getname() returns.

Couldn't you just use some of the free pointers in struct page?
(lru etc.)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
