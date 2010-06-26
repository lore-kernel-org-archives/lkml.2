Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab0FZONe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 10:13:34 -0400
Received: from mailgw02.dd24.net ([193.46.215.43]:42505 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0FZONc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 10:13:32 -0400
Subject: Re: (stupid) how to specify the root-device via kernel parameters
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-kernel@vger.kernel.org
In-Reply-To: <20100626134638.GQ6843@thunk.org>
References: <1277553549.29791.38.camel@fermat.scientia.net>
	 <20100626134638.GQ6843@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Jun 2010 16:13:26 +0200
Message-ID: <1277561606.3245.35.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-26 at 09:46 -0400, tytso@mit.edu wrote:
> Abuse this how?  What do you think is "wrong"?
Uhm... not totally sure as I only had a first short glance on it (so I
hope not to step on Bastian's toes ;) )... but the lvm2 initramfs-script
from Debian's lvm2 package somehow to set up the VGs/LVs... which is
fine, expect you have fully encrypted fs (with boot on USB stick),...
and you have a dm-crypt device on top of LVM.
Not sure why he simply doesn't do a vgchange -an or so,.. but will ask
him.

Then my root is /dev/mapper/root or so,... and the script has it's
problem.


Cheers,
Chris.

