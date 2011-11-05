Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1KEPzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 11:55:14 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:50125 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752432Ab1KEPzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 11:55:12 -0400
Message-ID: <4EB55C2D.5080208@xenotime.net>
Date: Sat, 05 Nov 2011 08:54:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Vsevolod Alekseev <vsevolod.alekseev@gmx.com>
CC: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix misc typos/grammar errors in comments
References: <1320485728-2103-1-git-send-email-vsevolod.alekseev@gmx.com>
In-Reply-To: <1320485728-2103-1-git-send-email-vsevolod.alekseev@gmx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2011 02:35 AM, Vsevolod Alekseev wrote:
> Fix various typos/grammar errors in include/linux/security.h comments (no code changes).
> 
> Signed-off-by: Vsevolod Alekseev <vsevolod.alekseev@gmx.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  include/linux/security.h |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 19d8e04..94c3533 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
