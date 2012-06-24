Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2FXX3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:29:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53067 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab2FXX3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:29:34 -0400
Message-ID: <4FE7A2D9.1090001@landley.net>
Date: Sun, 24 Jun 2012 18:29:29 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
CC: daniel.santos@pobox.com, Daniel Santos <danielfsantos@att.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v4 0/13] Generic Red-Black Trees
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com> <4FE661F8.3000109@att.net> <4FE69A14.6040904@landley.net> <201206240957.09136.pisa@cmp.felk.cvut.cz>
In-Reply-To: <201206240957.09136.pisa@cmp.felk.cvut.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2012 02:57 AM, Pavel Pisa wrote:
> So again, please, test LLVM or other your beloved
> compilers and report if there is a problem.

He already addressed my concerns.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
