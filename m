Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab2GWPu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:50:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51406 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab2GWPuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:50:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/13] UAPI header file split
Date: Mon, 23 Jul 2012 15:50:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org, davej@redhat.com
References: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231550.43775.arnd@arndb.de>
X-Provags-ID: V02:K0:4sINBobjRlEJct9FVzxCF/cI0mkYWoMI2Tx40lKjOov
 bdc601lLSHRYpbRWe8jk8XBTIPBfDF8rrBfm3qF+Gkqf9M4I4U
 1AhpWcBQSEGC1liIBOhUHPfw0DFWeHqBOk7utJrjPfDYXdm4hw
 pHTqMGJi/dpHISBpArGNeVeTJgsXTt0wRJ9DDy7uACKXi7vu4T
 NJ8P8L168rT3mrxtPacZPXQFBBOnKWDENV0jmewIxViOk7QMYi
 1GACkaNZQeZLd1Kl+sMqRznzp6R3E6xYIeFV9cv1WznaI6XKy3
 6uL2Mv9jDC7NgsLHFKegaNxD04t4W7yEZCG6rGADcs7VX1MYcE
 laMVkCnaePlS7PjENx1M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2012, David Howells wrote:
>      (a) It reduces the size of the kernel-only headers and obviates the need
>          for __KERNEL__ conditionals in the remnant kernel-only headers.
> 
>      (b) In what we have today, there are complex interdependencies between
>          headers that are partly exported to user space, and we want to reduce
>          those interdependencies.
> 
>          It simplifies the problem space by splitting out the user headers as
>          they then only depend only on other user headers.
> 
>      This step makes it easier to follow through with the remaining steps as
>      the remnant kernel headers can be split up without regard as to whether
>      the UAPI will be broken.  Header files such as linux/sched.h can even
>      disappear entirely if that seems convenient.
> 
>      There is another potential benefit as well: it becomes easier to track
>      when the UAPI changes just from the filenames in the GIT log.
> 
>      Further, linux-api@vger.kernel.org can be put into the MAINTAINERS file
>      for the uapi/ directories so that patches changing them get sent to that
>      list by everyone using get_maintainer.pl.

Looks all good to me. For the entire series:

Acked-by: Arnd Bergmann <arnd@arndb.de>
