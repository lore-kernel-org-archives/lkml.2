Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab0CZFDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 01:03:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab0CZFDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 01:03:03 -0400
Date: Fri, 26 Mar 2010 10:31:09 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org,
       Virtualization List <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Problem with multiple hvc consoles via virtio-console
Message-ID: <20100326050109.GK8111@amit-x200.redhat.com>
References: <20100324153408.GB18581@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324153408.GB18581@amit-x200.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) Mar 24 2010 [21:04:08], Amit Shah wrote:
> Hello,
> 
> When multiple hvc console ports are initialised and used via the
> virtio_console driver, I can interact with only the first console, the
> 2nd one doesn't respond.
> 
> If I call hvc_kick() even if hvc_poll() returns 0, the 2nd console
> becomes responsive.

Actually it's not that fancy: if I login to the first console (hvc0) and
then spawn another one (hvc1), I can't login into hvc1. If I spawn hvc1
before logging into hvc0, I can work with both.

		Amit
