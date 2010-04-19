Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0DSMfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:35:32 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:34676 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0DSMfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:35:31 -0400
MIME-Version: 1.0
In-Reply-To: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 19 Apr 2010 14:35:13 +0200
Message-ID: <z2iac3eb2511004190535pa4209f50n80708879a6b705e1@mail.gmail.com>
Subject: Re: request_firmware API exhaust memory
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH <greg@kroah.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 14:20, Tomas Winkler <tomasw@gmail.com> wrote:
> Lately we've been developing a device that rather more extensively
> used request_firmware API in load and also using pm_notifiers to load
> firmware. In some stress  testing the usage will exhaust the system
> memory. First we suspected there is a memory leak in the
> firwmare_class but eventually what is that udevd piles up it takes
> time to collect the process.

What version of the kernel, and what version of udev?

> We loose ~ 500K for each
> request/release_firmware iteration.

You mean you lose 500k, not taken by any process?

> After the stress the process table will will look something like shown below,

What are these processes doing (strace)? Do they have child processes?
If yes, what are they doing (strace)?

Kay
