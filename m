Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab0LAUvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:51:55 -0500
Received: from xenotime.net ([72.52.115.56]:38158 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757122Ab0LAUvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:51:54 -0500
Date: Wed, 1 Dec 2010 12:51:51 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: kernel-docs: fix typos, remove
 duplicated entries
Message-Id: <20101201125151.81d1a3d2.rdunlap@xenotime.net>
In-Reply-To: <20101201184821.6be9560d@absol.kitzblitz>
References: <20101201184821.6be9560d@absol.kitzblitz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010 18:48:21 +0100 Nicolas Kaiser wrote:

> Fixed typos, and removed duplicated entries.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Applied, thanks.


> ---
>  Documentation/kernel-docs.txt |   27 ++-------------------------
>  1 files changed, 2 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/kernel-docs.txt b/Documentation/kernel-docs.txt
> index 715eaaf..9a86746 100644
> --- a/Documentation/kernel-docs.txt
> +++ b/Documentation/kernel-docs.txt
> @@ -537,7 +537,7 @@
>         Notes: Further information in
>         http://www.oreilly.com/catalog/linuxdrive2/
>  
> -     * Title: "Linux Device Drivers, 3nd Edition"
> +     * Title: "Linux Device Drivers, 3rd Edition"
>         Authors: Jonathan Corbet, Alessandro Rubini, and Greg Kroah-Hartman
>         Publisher: O'Reilly & Associates.
>         Date: 2005.
> @@ -592,14 +592,6 @@
>         Pages: 600.
>         ISBN: 0-13-101908-2
>  
> -     * Title:  "The  Design  and Implementation of the 4.4 BSD UNIX
> -       Operating System"
> -       Author: Marshall Kirk McKusick, Keith Bostic, Michael J. Karels,
> -       John S. Quarterman.
> -       Publisher: Addison-Wesley.
> -       Date: 1996.
> -       ISBN: 0-201-54979-4
> -
>       * Title: "Programming for the real world - POSIX.4"
>         Author: Bill O. Gallmeister.
>         Publisher: O'Reilly & Associates, Inc..
> @@ -610,28 +602,13 @@
>         POSIX. Good reference.
>  
>       * Title:  "UNIX  Systems  for  Modern Architectures: Symmetric
> -       Multiprocesssing and Caching for Kernel Programmers"
> +       Multiprocessing and Caching for Kernel Programmers"
>         Author: Curt Schimmel.
>         Publisher: Addison Wesley.
>         Date: June, 1994.
>         Pages: 432.
>         ISBN: 0-201-63338-8
>  
> -     * Title:  "The  Design  and Implementation of the 4.3 BSD UNIX
> -       Operating System"
> -       Author: Samuel J. Leffler, Marshall Kirk McKusick, Michael J.
> -       Karels, John S. Quarterman.
> -       Publisher: Addison-Wesley.
> -       Date: 1989 (reprinted with corrections on October, 1990).
> -       ISBN: 0-201-06196-1
> -
> -     * Title: "The Design of the UNIX Operating System"
> -       Author: Maurice J. Bach.
> -       Publisher: Prentice Hall.
> -       Date: 1986.
> -       Pages: 471.
> -       ISBN: 0-13-201757-1
> -
>       MISCELLANEOUS:
>  
>       * Name: linux/Documentation
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
