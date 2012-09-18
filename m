Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab2IRPey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 11:34:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989Ab2IRPew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 11:34:52 -0400
Date: Tue, 18 Sep 2012 17:36:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH -mm v2] coredump: extend core dump note section to
	contain file names of mapped files
Message-ID: <20120918153650.GA22122@redhat.com>
References: <1347980129-1510-1-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347980129-1510-1-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Denys Vlasenko wrote:
>
> Changes since previous version: rediffed on top of NT_SIGINFO patches.

Assuming this is the only change:

Again, I can't judge whether we need this feature or not, although
I tend to trust Denys who actually works with the user-space tools
which play with coredumps.

But, from the correctness pov
Reviewed-by: Oleg Nesterov <oleg@redhat.com>

