Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0KTO51 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 09:57:27 -0500
Received: from www17.your-server.de ([213.133.104.17]:52060 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0KTO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 09:57:26 -0500
Subject: Re: [00/66] 2.6.36.1-stable review
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <20101119220309.GA15562@kroah.com>
References: <20101119220309.GA15562@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Nov 2010 16:56:42 +0100
Message-ID: <1290268602.10615.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 19.11.2010, 14:03 -0800 schrieb Greg KH:
> This is the start of the stable review cycle for the 2.6.36.1 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.

This one is missing and crashes my 2.6.36 kernel:

https://bugzilla.kernel.org/show_bug.cgi?id=22922

This was fixed in 2.6.37-rc1 in commit: a1c6c5698d53 (ext4: fix
NULL pointer dereference in print_daily_error_info())

kind regards
thomas


