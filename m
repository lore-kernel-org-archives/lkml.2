Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab0DMSkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:40:21 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42208 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0DMSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jPd0HGBBR8Hj0c5SifXCLUKjZXdCRY8xHvqZbHNkEsgRfzFZGXXpIL0Xz3z7Ca4HNa
         3sN/7DbdV2cmCTyenmOsZyzKy7nQz/AyjZHICAQxgmZ73QILEzZeKqfZHYy9pG4mdNkS
         bupZaDnhXApnKlsNwlUPbN32M7Ky/mFjGCE5w=
Subject: Re: [PATCH] Add somaxconn to Documentation/sysctl/net.txt
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <201004131325.29104.rob@landley.net>
References: <201004131325.29104.rob@landley.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 20:40:12 +0200
Message-ID: <1271184012.16881.549.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 avril 2010 à 13:25 -0500, Rob Landley a écrit :
> From: Rob Landley <rob@landley.net>
> 
> Add somaxconn to Documentation/sysctl/net.txt
> 
> Signed-off-by: Rob Landley <rob@landley.net>
> ---
> 
>  Documentation/sysctl/net.txt |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/sysctl/net.txt b/Documentation/sysctl/net.txt
> index df38ef0..2740085 100644
> --- a/Documentation/sysctl/net.txt
> +++ b/Documentation/sysctl/net.txt
> @@ -90,6 +90,12 @@ optmem_max
>  Maximum ancillary buffer size allowed per socket. Ancillary data is a sequence
>  of struct cmsghdr structures with appended data.
>  
> +somaxconn
> +---------
> +
> +Maximum backlog of unanswered connections for a listening socket.  Provides
> +an upper bound on the "backlog" parameter of the listen() syscall.
> +
>  2. /proc/sys/net/unix - Parameters for Unix domain sockets
>  -------------------------------------------------------
>  
> 

Please cc netdev for such patches

Extract of Documentation/networking/ip-sysctl.txt

somaxconn - INTEGER
	Limit of socket listen() backlog, known in userspace as SOMAXCONN.
	Defaults to 128.  See also tcp_max_syn_backlog for additional tuning
	for TCP sockets.

I guess you need to change both files ?


