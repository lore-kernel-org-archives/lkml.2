Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2LVEWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:22:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab2LVEWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:22:03 -0500
Message-ID: <50D53639.6040604@redhat.com>
Date: Fri, 21 Dec 2012 23:25:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] mm: make mlockall preserve flags other than VM_LOCKED
 in def_flags
References: <1356050997-2688-1-git-send-email-walken@google.com> <1356050997-2688-2-git-send-email-walken@google.com>
In-Reply-To: <1356050997-2688-2-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:49 PM, Michel Lespinasse wrote:
> On most architectures, def_flags is either 0 or VM_LOCKED depending on
> whether mlockall(MCL_FUTURE) was called. However, this is not an absolute
> rule as kvm support on s390 may set the VM_NOHUGEPAGE flag in def_flags.
> We don't want mlockall to clear that.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

