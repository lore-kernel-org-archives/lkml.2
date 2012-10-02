Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab2JBVRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:17:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2JBVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:17:35 -0400
Date: Tue, 2 Oct 2012 14:17:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] aoe: make dynamic block minor numbers the default
Message-Id: <20121002141734.56ee52b3.akpm@linux-foundation.org>
In-Reply-To: <4b1456739285d5a7a153ba74a51f3e3bfd5c4a53.1349104674.git.ecashin@coraid.com>
References: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
	<4b1456739285d5a7a153ba74a51f3e3bfd5c4a53.1349104674.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012 19:05:15 -0700
Ed Cashin <ecashin@coraid.com> wrote:

> Because udev use is so widespread, making the old static mapping
> the default is too conservative, given the severe limitations it
> places on usable AoE addresses.  Storage virtualization and
> larger shelves have made the old limitations too confining.
> 
> These changes make the dynamic block device minor numbers the
> default, removing the limitations on usable AoE addresses.
> 
> The static arrangement is still available with aoe_dyndevs=0, and
> the aoe-stat tool from the userland aoetools package, the user
> space counterpart to the aoe driver, recognizes the case where
> there is a mismatch between the minor number in sysfs and the
> minor number in a special device file.

Oh.  There we are.

Again, what are the back-(in)compatibility issues which users might
encounter with this?

