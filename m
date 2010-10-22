Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0JVTsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:48:04 -0400
Received: from legolas.restena.lu ([158.64.1.34]:40550 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab0JVTsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:48:02 -0400
Date: Fri, 22 Oct 2010 21:46:43 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
Subject: Re: [PATCH 1/5] cciss: remove controllers supported by hpsa
Message-ID: <20101022214643.61dcafdd@neptune.home>
In-Reply-To: <20101022192101.25567.40578.stgit@beardog.cce.hp.com>
References: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
	<20101022192101.25567.40578.stgit@beardog.cce.hp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 October 2010 "Stephen M. Cameron" wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> We would prefer not to have any overlap between the two drivers.
> Remove the cciss_allow_hpsa option, as it it is no longer needed.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

I think it would be helpful to provide clear indication in cciss'
Kconfig description about which controllers are the last ones to be
supported by cciss and starting from which ones hpsa is needed.

In addition the dev_warn before returning -ENODEV could include a
hint that newish controllers need hpsa driver instead of just saying
"unrecognized board ...", this at least when hpsa driver was not
included in kernel build.

Regards,
Bruno
