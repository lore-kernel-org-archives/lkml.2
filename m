Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162176Ab2CSQhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:37:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28239 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031218Ab2CSQhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:37:01 -0400
MIME-Version: 1.0
Message-ID: <6a7183b7-0fa1-4ae0-ba49-273f253496af@default>
Date: Mon, 19 Mar 2012 09:06:26 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@ORACLE.COM>
To: Konrad Rzeszutek Wilk <konrad.wilk@ORACLE.COM>, dan.magenheimer@ORACLE.COM,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH] MAINTAINERS: Adding cleancache API to the list.
References: <<1332172165-4362-1-git-send-email-konrad.wilk@oracle.com>>
 <<1332172165-4362-2-git-send-email-konrad.wilk@oracle.com>>
In-Reply-To: <<1332172165-4362-2-git-send-email-konrad.wilk@oracle.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F6760AC.011A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Monday, March 19, 2012 9:49 AM
> To: dan.magenheimer@oracle.com; linux-kernel@vger.kernel.org
> Cc: Konrad Rzeszutek Wilk
> Subject: [PATCH] MAINTAINERS: Adding cleancache API to the list.
> 
> .. and electing myself as the maintainer.
> 
> CC: Dan Magenheimer <dan.magenheimer@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

> ---
>  MAINTAINERS |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9c63a43..e1a70cb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1831,6 +1831,13 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
>  S:	Supported
>  F:	sound/soc/codecs/cs4270*
> 
> +CLEANCACHE API
> +M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	mm/cleancache.c
> +F:	include/linux/cleancache.h
> +
>  CLK API
>  M:	Russell King <linux@arm.linux.org.uk>
>  F:	include/linux/clk.h
> --
> 1.7.7.5
