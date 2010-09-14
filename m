Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0INPtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:49:45 -0400
Received: from b.mail.sonic.net ([64.142.19.5]:34296 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab0INPtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:49:43 -0400
X-Greylist: delayed 723 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Sep 2010 11:49:43 EDT
Message-ID: <4C8F96BB.2040609@twiddle.net>
Date: Tue, 14 Sep 2010 08:37:31 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: Re: [PATCH next 01/16] arch/alpha: Use static const char * const
 where possible
References: <cover.1284435709.git.joe@perches.com> <3b211935182d8ac989fbdfde01fbdc25077151a9.1284435709.git.joe@perches.com>
In-Reply-To: <3b211935182d8ac989fbdfde01fbdc25077151a9.1284435709.git.joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 09:23 PM, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/alpha/kernel/err_ev6.c    |   12 +++++++-----
>  arch/alpha/kernel/err_marvel.c |   33 +++++++++++++++++----------------
>  arch/alpha/kernel/err_titan.c  |   35 ++++++++++++++++++++---------------
>  arch/alpha/kernel/osf_sys.c    |    4 ++--
>  4 files changed, 46 insertions(+), 38 deletions(-)

Acked-by: Richard Henderson  <rth@twiddle.net>


r~
