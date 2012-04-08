Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab2DHWuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:50:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59487 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab2DHWuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:50:22 -0400
MIME-Version: 1.0
In-Reply-To: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
Date: Sun, 8 Apr 2012 15:50:21 -0700
X-Google-Sender-Auth: zlINliAv7Xsu7GgWlJre7WZ3K58
Message-ID: <CAA9_cmc9=aOexD8MBViEd9H=-Z79CMtn0-HE3ZXMwHQtTuRMzg@mail.gmail.com>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
From: Dan Williams <dan.j.williams@intel.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 5:11 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
[..]
>  drivers/scsi/isci/init.c                           |    2 +-
[..]
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index eb0f56c..7a8da32 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -809,7 +809,7 @@ static __exit void isci_exit(void)
>        sas_release_transport(isci_transport_template);
>  }
>
> -MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_LICENSE("GPL-Compatible");
>  MODULE_FIRMWARE(ISCI_FW_NAME);
>  module_init(isci_init);
>  module_exit(isci_exit);

Per Alan's comments, Nak on the isci driver changes.

--
Dan
