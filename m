Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0IQUco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:32:44 -0400
Received: from www.tglx.de ([62.245.132.106]:42804 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab0IQUcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:32:43 -0400
Date: Fri, 17 Sep 2010 22:32:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] uio: Fix lack of locking in init_uio_class
In-Reply-To: <m1sk1c895g.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1009172231580.2416@localhost6.localdomain6>
References: <m1y6b48973.fsf@fess.ebiederm.org> <m1sk1c895g.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Sep 2010, Eric W. Biederman wrote:

> 
> There is no locking in init_uio_class so multiple
> drivers can race and create multiple uio classes.
> 
> Fix this by simplifying the code.   In particular always
> register the uio class during module_init and make things
> simpler.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
