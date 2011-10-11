Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1JKQAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:00:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65282 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab1JKQAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:00:36 -0400
MIME-Version: 1.0
In-Reply-To: <1318260152-2786-1-git-send-email-mark.einon@gmail.com>
References: <1318260152-2786-1-git-send-email-mark.einon@gmail.com>
Date: Tue, 11 Oct 2011 09:00:35 -0700
Message-ID: <CAP2e6W9oQWLxe7pJxk=Awn1HTueeu41ZV7TFF+V9tHF07_Mxag@mail.gmail.com>
Subject: Re: [PATCH 4/4] staging: et131x: Update TODO list
From: Ramesh R <rshlinux@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I wish to contribute to this project - From the latest TODO list in
the README document

drivers/staging/et131x/README

If I were to start with the coding style cleanups, is there a coding
standard available for reference? Please advice.

Thanks
Ramesh

On Mon, Oct 10, 2011 at 8:22 AM, Mark Einon <mark.einon@gmail.com> wrote:
> Added some more tasks to the TODO list, as highlighted by Francois
> Romieu <romieu@fr.zoreil.com>.
>
> Signed-off-by: Mark Einon <mark.einon@gmail.com>
> ---
>  drivers/staging/et131x/README |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
> index d383e80..c67f83e 100644
> --- a/drivers/staging/et131x/README
> +++ b/drivers/staging/et131x/README
> @@ -2,13 +2,18 @@ This is a driver for the ET1310 network device.
>
>  Based on the driver found at https://sourceforge.net/projects/et131x/
>
> -Cleaned up immensely by Olaf Hartman and Christoph
> -Hellwig <hch@infradead.org>
> +Cleaned up immensely by Olaf Hartman and Christoph Hellwig <hch@infradead.org>
>
>  Note, the powermanagement options were removed from the vendor provided
>  driver as they did not build properly at the time.
>
>  TODO:
> +       - Put the driver into a single file, with a .h for the registers layout.
> +       - rx_ring.fbr{0, 1} can probably share a common structure
> +       - Use of kmem_cache seems a bit unusual
> +       - Use dma_alloc_... in place of pci_alloc_...
> +       - It's too late stopping the tx queue when there is no room for the current packet. The condition should be detected for the next packet.
> +       - PCI_VDEVICE ?
>
>  Please send patches to:
>        Greg Kroah-Hartman <gregkh@suse.de>
> --
> 1.7.6.4
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>
