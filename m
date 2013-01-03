Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3ACFrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 00:47:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab3ACFrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 00:47:40 -0500
Message-ID: <50E51B6A.9080907@redhat.com>
Date: Thu, 03 Jan 2013 00:47:22 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] mm: use mm_populate() for mremap() of VM_LOCKED vmas
References: <1356050997-2688-1-git-send-email-walken@google.com> <1356050997-2688-7-git-send-email-walken@google.com>
In-Reply-To: <1356050997-2688-7-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:49 PM, Michel Lespinasse wrote:
> Signed-off-by: Michel Lespinasse <walken@google.com>

Changelog?

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
