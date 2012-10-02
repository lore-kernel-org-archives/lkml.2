Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2JBTex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:34:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:6416 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab2JBTev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:34:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,524,1344236400"; 
   d="scan'208";a="151642926"
From: Andi Kleen <andi@firstfloor.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com
Subject: Re: [RFC, PATCH] Extensible AIO interface
References: <20121001222341.GF26488@google.com>
Date: Tue, 02 Oct 2012 12:34:33 -0700
In-Reply-To: <20121001222341.GF26488@google.com> (Kent Overstreet's message of
	"Mon, 1 Oct 2012 15:23:41 -0700")
Message-ID: <m2r4pgwtva.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> So, I and other people keep running into things where we really need to
> add an interface to pass some auxiliary... stuff along with a pread() or
> pwrite().

How would you enumerate this? 
How does the application know what the underlying stack supports/need?
How is versioning handled?

Frankly, in this form it looks more like a special purpose hack than a general
facility. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
