Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0CXV64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:58:56 -0400
Received: from xenotime.net ([72.52.64.118]:36273 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752147Ab0CXV6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:58:55 -0400
Message-ID: <4BAA8B1D.6000705@xenotime.net>
Date: Wed, 24 Mar 2010 14:58:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: Paul Menage <menage@google.com>, Jiri Kosina <jkosina@suse.cz>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geunsik Lim <geunsik.lim@samsung.com>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] cpuset: Fix documentation punctuation
References: <1269467310-27685-1-git-send-email-gthelen@google.com>
In-Reply-To: <1269467310-27685-1-git-send-email-gthelen@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/10 14:48, Greg Thelen wrote:
> Fix cpusets.txt documentation punctuation.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  Documentation/cgroups/cpusets.txt |   38 ++++++++++++++++++------------------
>  1 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
> index 4160df8..51682ab 100644
> --- a/Documentation/cgroups/cpusets.txt
> +++ b/Documentation/cgroups/cpusets.txt

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Jiri, would you merge this, please?

thanks,
-- 
~Randy
