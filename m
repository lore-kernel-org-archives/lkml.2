Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1K1Xle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:41:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57057 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab1K1Xlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:41:32 -0500
MIME-Version: 1.0
In-Reply-To: <1322520574.24241.10.camel@mars>
References: <1322520574.24241.10.camel@mars>
Date: Mon, 28 Nov 2011 15:41:32 -0800
Message-ID: <CA+8MBbJ6PtMMoeRYrg9fQqwsi3=RYwMU52bmDRb0Bk_4uXOBXQ@mail.gmail.com>
Subject: Re: [PATCH] efivars: add missing parameter to efi_pstore_read()
From: Tony Luck <tony.luck@gmail.com>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Garrett <mjg@redhat.com>, Dan Carpenter <error27@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 2:49 PM, Christoph Fritz
<chf.fritz@googlemail.com> wrote:
> In the case where CONFIG_PSTORE=n, the function efi_pstore_read() doesn't
> have the correct list of parameters. This patch provides a definition
> of efi_pstore_read() with 'char **buf' added to fix this warning:
> "drivers/firmware/efivars.c:609: warning: initialization from".

Thanks.  Will ask Linus to pull from my tree soon - but if someone
else pushes it consider it:

Acked-by: Tony Luck <tony.luck@intel.com>

-Tony

[This has been broken in linux-next for over a week - I guess all
linux-next builders have PSTORE=y]
