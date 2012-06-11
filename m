Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2FKWIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:08:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49002 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2FKWIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:08:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120611160438.GA24331@kroah.com>
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
	<1339110229-19383-4-git-send-email-solid.se7en@gmail.com>
	<20120611160438.GA24331@kroah.com>
Date: Mon, 11 Jun 2012 15:08:13 -0700
Message-ID: <CALJ0CeiibyAAJQC4kVxMLTEx=6dzZdzivpfHi4b3W-dst3Ha6w@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] staging: zram: conventions, line splitting
From: Sam Hansen <sam@meebo-inc.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sam Hansen <solid.se7en@gmail.com>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  drivers/staging/zram/zram_drv.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> This patch no longer applies to the tree :(

Hi Greg,
I wrote the patch against Linus' tree
<http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git>.
Is it more appropriate to write code against your staging tree
<http://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git>?

Have I been writing code against the wrong tree?  If so,  I'm a huge
tool and sorry for the confusion :p

I'm also doing a huge cleanup of the wan-pmc drivers (cxt1e1) and will
port over to your repo if necessary.

Thanks!

-sam
<solid.se7en@gmail.com>
