Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab0JFPPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:15:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57992 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160Ab0JFPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:15:39 -0400
Date: Wed, 6 Oct 2010 11:15:26 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: btrfs oops on dodgy SSD
Message-ID: <20101006151526.GP9759@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Airlie <airlied@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <AANLkTiknCR6Z2=L9FoA8+m7o8dw6=Hq1QHWKn7Oyf9UF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiknCR6Z2=L9FoA8+m7o8dw6=Hq1QHWKn7Oyf9UF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 11:07:10AM +1000, Dave Airlie wrote:
> I have an SSD which I use for scratch builds and stuff, it seems to be
> broken or just dislike my NV sata controller.
> 
> Was just running Linus tree and got the attached oops when doing a
> kernel build on it this morning.
> 
> oops didn't come out in logs, though there were some disk reset and a
> hung task detect.
> 
> Might help btrfs robustness maybe if we could avoid the panic ;-)

Ouch, the oops was in the code printing a corrupted btree block.  I
should be able to easily trigger this at home...

-chris
