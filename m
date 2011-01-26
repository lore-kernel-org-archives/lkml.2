Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1AZHnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:43:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40639 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab1AZHnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:43:04 -0500
Message-ID: <4D3FD035.3090604@zytor.com>
Date: Tue, 25 Jan 2011 23:41:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Ian Kent <raven@themaw.net>, autofs@linux.kernel.org
Subject: Re: [PATCH 06/20] staging: Remove autofs3
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-7-git-send-email-arnd@arndb.de>
In-Reply-To: <1295993854-4971-7-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 02:17 PM, Arnd Bergmann wrote:
> autofs3 was moved to staging in 2.6.37, so we can
> remove it in the 2.6.39 merge window. If we have
> a reason to bring it back after that, this patch
> can get reverted.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ian Kent <raven@themaw.net>
> Cc: autofs@linux.kernel.org

About-fscking-timed-by: H. Peter Anvin <hpa@zytor.com>

;)

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

