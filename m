Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0I1NCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:02:17 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:57846 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab0I1NCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:02:16 -0400
Date: Tue, 28 Sep 2010 15:02:14 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: matt mooney <mfm@muteddisk.com>
Cc: kernel-janitors@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/24] misc: change to new flag variable
Message-ID: <20100928130214.GC3388@rere.qmqm.pl>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com> <c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 12:17:23PM -0700, matt mooney wrote:
> Replace EXTRA_CFLAGS with ccflags-y.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
>  drivers/misc/cb710/Makefile   |    4 +---
>  drivers/misc/sgi-gru/Makefile |    4 +---
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/misc/cb710/Makefile b/drivers/misc/cb710/Makefile
> index 7b80cbf..467c8e9 100644
> --- a/drivers/misc/cb710/Makefile
> +++ b/drivers/misc/cb710/Makefile
> @@ -1,6 +1,4 @@
> -ifeq ($(CONFIG_CB710_DEBUG),y)
> -	EXTRA_CFLAGS		+= -DDEBUG
> -endif
> +ccflags-$(CONFIG_CB710_DEBUG)	:= -DDEBUG
>  
>  obj-$(CONFIG_CB710_CORE)	+= cb710.o
>  

In case you need it:

Acked-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

