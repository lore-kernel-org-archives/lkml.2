Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3ACC0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 21:26:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab3ACC0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 21:26:00 -0500
Message-ID: <50E4EC2D.4080503@redhat.com>
Date: Wed, 02 Jan 2013 21:25:49 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] mm: use mm_populate() for blocking remap_file_pages()
References: <1356050997-2688-1-git-send-email-walken@google.com> <1356050997-2688-5-git-send-email-walken@google.com>
In-Reply-To: <1356050997-2688-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:49 PM, Michel Lespinasse wrote:
> Signed-off-by: Michel Lespinasse <walken@google.com>

Changelog could use some help :)

Other than that:

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
