Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1CYTiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:38:52 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:56934 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971Ab1CYTiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:38:51 -0400
Date: Fri, 25 Mar 2011 20:36:07 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] docs: update the development process document
Message-ID: <20110325203607.05061aa2@absol.kitzblitz>
In-Reply-To: <20110325123031.45b6a217@bike.lwn.net>
References: <20110325123031.45b6a217@bike.lwn.net>
Organization: -
X-Face: $xTGJu&(Z}Kfc6oh3GO!eMHXw^2Et>fwLz-kFiy~w-$|,?fpR]*oRZ{`YA1MYCAg2<`SYC]
 gxT(i'\0JFp:-qC.Y_sj>|&iiqoh1Q`5g_)%+6oq&jjC,Uze5#7bt|B1ST%[(yi8LihLZL$X
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jonathan Corbet <corbet@lwn.net>:
> @@ -287,25 +293,14 @@ Some information about linux-next has been gathered at:
>  
>  	http://linux.f-seidel.de/linux-next/pmwiki/
>  
> -How the linux-next tree will fit into the development process is still
> -changing.  As of this writing, the first full development cycle involving
> -linux-next (2.6.26) is coming to an end; thus far, it has proved to be a
> -valuable resource for finding and fixing integration problems before the
> -beginning of the merge window.  See http://lwn.net/Articles/287155/ for
> -more information on how linux-next has worked to set up the 2.6.27 merge
> -window.
> -
> -Some developers have begun to suggest that linux-next should be used as the
> -target for future development as well.  The linux-next tree does tend to be
> -far ahead of the mainline and is more representative of the tree into which
> -any new work will be merged.  The downside to this idea is that the
> -volatility of linux-next tends to make it a difficult development target.
> -See http://lwn.net/Articles/289013/ for more information on this topic, and
> -stay tuned; much is still in flux where linux-next is involved.
> +Linux-next has become an integral part of the kernel development process;
> +all patchs merged during a given merge window should really have found

patches

> +their way into linux-next some time before the merge window opens.
> +

Apart from that, looks great to me :)

Best regards,
Nicolas Kaiser
