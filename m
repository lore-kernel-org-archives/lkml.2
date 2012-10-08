Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2JHFtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:49:25 -0400
Received: from ozlabs.org ([203.10.76.45]:35197 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab2JHFtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:49:23 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, akpm@linux-foundation.org,
        andi@firstfloor.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
In-Reply-To: <1349654386-18378-2-git-send-email-kys@microsoft.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com> <1349654386-18378-1-git-send-email-kys@microsoft.com> <1349654386-18378-2-git-send-email-kys@microsoft.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 08 Oct 2012 16:15:55 +1030
Message-ID: <87obkdpld8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"K. Y. Srinivasan" <kys@microsoft.com> writes:
> +static int hot_add;
> +
> +module_param(hot_add, int, S_IRUGO);
> +MODULE_PARM_DESC(hot_add, "If set attempt memory hot_add");

I think this should be a 'bool', but I can't tell, since it's not used
in this patch.

Cheers,
Rusty.
