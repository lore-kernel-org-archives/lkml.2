Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1KNVah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:30:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab1KNVag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:30:36 -0500
Message-ID: <4EC188A5.4040005@suse.cz>
Date: Mon, 14 Nov 2011 22:31:17 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/tags.sh: Add Page flag function magic
References: <1320340197-9063-1-git-send-email-sboyd@codeaurora.org> <4EC15B2D.5000407@codeaurora.org>
In-Reply-To: <4EC15B2D.5000407@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 14.11.2011 19:17, Stephen Boyd napsal(a):
> On 11/03/11 10:09, Stephen Boyd wrote:
>> It takes a while to find the macro-magically defined Page*()
>> functions defined in include/linux/page-flags.h if you're new to
>> the kernel. Add some magic to the tags script to transform these
>> macros into the actual functions they are, so that tag jumping in
>> the mm code is a bit easier.
>>
>> Signed-off-by: Stephen Boyd<sboyd@codeaurora.org>
>> ---
>>
>
> ping?

Applied to kbuild.git#misc.

Michal
