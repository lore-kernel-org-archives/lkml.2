Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab1FTEGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 00:06:25 -0400
Received: from ozlabs.org ([203.10.76.45]:50771 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab1FTEGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 00:06:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
In-Reply-To: <1308434431.1050.5.camel@mop>
References: <1308434431.1050.5.camel@mop>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 20 Jun 2011 08:53:40 +0930
Message-ID: <8739j59zib.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011 00:00:29 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: module: sysfs - add 'uevent' file to allow built-in coldplug
> 
> Userspace wants to manage module parameters with udev rules.
> This currently only works for loaded modules, but not for
> built-in ones.

I'm confused.  What does "manage" mean here?

Thanks,
Rusty.
