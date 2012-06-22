Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab2FVLkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:40:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:29867 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760114Ab2FVLkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:40:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183663932"
Date: Fri, 22 Jun 2012 12:56:19 +0100
From: Alan Cox <alan@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Doug Ledford <dledford@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] fs: introduce pipe-only dump mode suid_dumpable=3
Message-ID: <20120622125619.28b36311@bob.linux.org.uk>
In-Reply-To: <20120622000049.GA7877@www.outflux.net>
References: <20120622000049.GA7877@www.outflux.net>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch introduces suid_dumpable=3 to allow privilege-changed
> processes to be dumped only to a pipe handler (and not directly to
> disk). The value of suid_dumpable=2 is now deprecated, and attempting
> to set this sysctl value returns -EINVAL.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Alan Cox <alan@linux.intel.com>
