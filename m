Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab1JGWHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 18:07:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54664 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab1JGWHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 18:07:20 -0400
MIME-Version: 1.0
From: Mark Einon <mark.einon@gmail.com>
Date: Fri, 7 Oct 2011 23:07:00 +0100
Message-ID: <CANK3SE398D+DiXLWDystz_jSpD4WJaLqt9gCmVstr+8TginDRw@mail.gmail.com>
Subject: et131x: Moving the et131x driver out of staging? (a.k.a. filling up
 the TODO list again)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linville@tuxdriver.com, davem@davemloft.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

I've managed to clear out the current TODO list for the staging/et131x
driver, and hopefully its looking in a much better shape because of
it.

I'd like to propose moving it out of the staging area, or at least
getting some review comments regarding what work is still needed.

Is it a good time to propose this bearing in mind the reorganisation
of drivers/net/ and the fallout from the kernel.org issues?

The only outstanding issue I know of, which is yet to hit your staging tree is:

On 1 October 2011 20:58, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>... the driver doesn't
> compile any more.  The Kconfig file says it "depends on NETDEV_1000"
> but NETDEV_1000 isn't around any more since f860b0522f65d3
> "drivers/net: Kconfig and Makefile cleanup" was merged.

Cheers,

Mark
