Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1HANYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:24:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35136 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1HANYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:24:05 -0400
Date: Mon, 1 Aug 2011 17:23:59 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Linux-MIPS <linux-mips@linux-mips.org>
Subject: Re: shm broken on MIPS in current -git
Message-ID: <20110801132359.GA11158@albatros>
References: <CAOLZvyEQNS3dwQ+6bh2o6kADp7Gd3xOpah8y1_AhqJ2FWSP9VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOLZvyEQNS3dwQ+6bh2o6kADp7Gd3xOpah8y1_AhqJ2FWSP9VA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 14:51 +0200, Manuel Lauss wrote:
> Commits 5774ed014f02120db9a6945a1ecebeb97c2acccb
> (shm: handle separate PID namespaces case)
> and 4c677e2eefdba9c5bfc4474e2e91b26ae8458a1d
> (shm: optimize locking and ipc_namespace getting)
> break on my MIPS systems.  The following oops is
> printed on boot, and as a result, more than  300 zombie kworker
> kernel processes are resident.  I don't see this oops on x86 or x64.

Also it might help if you send the whole config file to me (privately,
as it is too big for ML).

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
