Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab0LNQHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:07:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:60101 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab0LNQHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:07:36 -0500
Message-ID: <4D079649.6030303@suse.cz>
Date: Tue, 14 Dec 2010 17:07:37 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <amwang@redhat.com>
Subject: Re: [PATCH] headers_check: better search for functions in headers
References: <1291134119-12903-1-git-send-email-virtuoso@slind.org>
In-Reply-To: <1291134119-12903-1-git-send-email-virtuoso@slind.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.11.2010 17:21, Alexander Shishkin wrote:
> Some headers don't bother with "extern" in function prototypes,
> which results in said prototypes being unnoticed and exported
> to userland.
>
> This patch slightly improves detection of such cases by checking
> for C type names as well in the beginning of a line.

Applied to kbuild-2.6.git#misc, thanks.

Michal
