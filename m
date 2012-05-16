Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2EPPRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:17:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47005 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2EPPRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:17:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120516145032.GA1139@kroah.com>
References: <1337108498-4104-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1205151527150.11923@router.home>
	<alpine.LFD.2.02.1205160935340.1763@tux.localdomain>
	<CAAmzW4PWQiKbs+mdnwG18R=iWHLT=4Bwn8iA110PJaKuvG_AQQ@mail.gmail.com>
	<20120516145032.GA1139@kroah.com>
Date: Thu, 17 May 2012 00:17:46 +0900
Message-ID: <CAAmzW4PA26qX8H1boKaHSh0m0S-aw7CVCTMeeijS-rCQEQzUdQ@mail.gmail.com>
Subject: Re: [PATCH] slub: fix a memory leak in get_partial_node()
From: JoonSoo Kim <js1304@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/16 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>> I read stable_kernel_rules.txt, this article tells me I must note
>> upstream commit ID.
>> Above patch is not included in upstream currently, so I can't find
>> upstream commit ID.
>> Is 'Acked-by from MAINTAINER' sufficient for submitting to stable-kernel?
>> Is below format right for stable submission format?
>
> No.
>
> Please read the second item in the list that says: "Procedure for
> submitting patches to the -stable tree" in the file,
> Documentation/stable_kernel_rulest.txt.  It states:
>
>  - To have the patch automatically included in the stable tree, add the tag
>     Cc: stable@vger.kernel.org
>   in the sign-off area. Once the patch is merged it will be applied to
>   the stable tree without anything else needing to be done by the author
>   or subsystem maintainer.
>
> Does that help?
>
> thanks,
>
> greg k-h

Thanks, very helpful.
