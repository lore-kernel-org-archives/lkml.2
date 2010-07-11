Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0GKCPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:15:36 -0400
Received: from govinda.solana.com ([198.99.130.30]:54745 "EHLO
	govinda.addtoit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0GKCPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:15:34 -0400
Date: Sat, 10 Jul 2010 22:15:26 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Philip Wernersbach <philip.wernersbach@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Calling system call from User-mode Linux?
Message-ID: <20100711021526.GA30049@c-98-229-117-200.hsd1.ma.comcast.net>
References: <AANLkTilvP8WDEyyZhNOraBtCeRk1ru1TmryFfEppTHB3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilvP8WDEyyZhNOraBtCeRk1ru1TmryFfEppTHB3@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 05:55:48PM -0400, Philip Wernersbach wrote:
> I'm trying to add some functionality to User-mode Linux that requires
> the UML kernel to call a custom syscall I've added to the host kernel.
> This should be technically possible since UML runs in the userspace,
> but I can't figure out how to call the syscall, as the syscall()
> function isn't defined in UML. Are there other ways I can accomplish
> this?

Add a function in the userspace side of UML (arch/um/os-Linux) which
invokes your new system call through syscall(), and then call that
from wherever you need to.

				Jeff
