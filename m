Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0JERIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:08:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab0JERIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:08:24 -0400
Message-ID: <4CAB5B52.4090404@redhat.com>
Date: Tue, 05 Oct 2010 13:07:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3] filemap_fault: unique path for locking page
References: <1286265215-9025-1-git-send-email-walken@google.com> <1286265215-9025-2-git-send-email-walken@google.com>
In-Reply-To: <1286265215-9025-2-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 03:53 AM, Michel Lespinasse wrote:
> This change introduces a single location where filemap_fault() locks
> the desired page. There used to be two such places, depending if the
> initial find_get_page() was successful or not.
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>
