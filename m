Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1JBSye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:54:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46722 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1JBSy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:54:29 -0400
MIME-Version: 1.0
In-Reply-To: <20111001195835.GA2925@longonot.mountain>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
 <1317464057-18231-7-git-send-email-mark.einon@gmail.com> <20111001195835.GA2925@longonot.mountain>
From: Mark Einon <mark.einon@gmail.com>
Date: Sun, 2 Oct 2011 19:54:09 +0100
Message-ID: <CANK3SE3g0Abt-Lr6AE2e0vsVQVx-Y2d_SZyLi+Uo0N0q+=HHdQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] staging: et131x: Updating copyright statements and
 module authors
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, o.hartmann@telovital.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 October 2011 20:58, Dan Carpenter <dan.carpenter@oracle.com>
wrote:> On Sat, Oct 01, 2011 at 11:14:16AM +0100, Mark Einon wrote:>>
@@ -945,5 +947,6 @@ module_exit(et131x_cleanup_module);>>>>  /*
Modinfo parameters (filled out using defines from et131x_version.h)
*/>>  MODULE_AUTHOR(DRIVER_AUTHOR);>>
+MODULE_AUTHOR(DRIVER_AUTHOR2);>>  MODULE_DESCRIPTION(DRIVER_INFO);>>
MODULE_LICENSE(DRIVER_LICENSE);>> Both DRIVER_AUTHOR and
DRIVER_AUTHOR2 are silly macros.  Put the name> in directly.  That way
you won't need the comment explaining where to> find the definitions.
Also normally people use gt lt brackets for> emails:>>
MODULE_AUTHOR("Victor Soriano <vjsoriano@agere.com>");>
MODULE_AUTHOR("Mark Einon <mark.einon@gmail.com>");>> Go ahead and fix
this in a later patch if you want.  All the macros> there should
probably be replaced.
Hi Dan, thanks for the feedback.Removing et131x_version.h file and
simplifying the macros is alreadyon my todo list.
>> Btw, the problems with kernel.org have complicated things here, so> I can't tell if you have already fixed this, but the driver doesn't> compile any more.  The Kconfig file says it "depends on NETDEV_1000"> but NETDEV_1000 isn't around any more since f860b0522f65d3> "drivers/net: Kconfig and Makefile cleanup" was merged.>
No, I've not experienced this issue yet. I'm using Greg's
staging-2.6tree, last updated at 7cbf3c7cd59 which doesn't have the
commit youmention.I'll look out for it when everything gets moving
again.
Cheers,
Mark
