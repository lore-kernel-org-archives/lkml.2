Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2EWFCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:02:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36746 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2EWFCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:02:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 23 May 2012 07:01:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux1394-devel <linux1394-devel@lists.sourceforge.net>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Boot <bootc@bootc.net>,
        Clemens Ladisch <clemens@ladisch.de>, Andy Grover <agrover@redhat.com>
Subject: Re: [GIT PULL] sbp-target merge for v3.5-rc1
Message-ID: <20120523070147.5e871477@stein>
In-Reply-To: <1337726029.22481.116.camel@haakon2.linux-iscsi.org>
References: <1337726029.22481.116.camel@haakon2.linux-iscsi.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 22 Nicholas A. Bellinger wrote:
[...]
>   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git sbp-target-merge
[...]
> Chris Boot (3):
>   firewire: Add function to get speed from opaque struct fw_request
>   firewire: Move fw_card kref functions into linux/firewire.h
>   sbp-target: Initial merge of firewire/ieee-1394 target mode support
> 
>  MAINTAINERS                         |    9 +
>  drivers/firewire/core-card.c        |    1 +
>  drivers/firewire/core-transaction.c |    9 +
>  drivers/firewire/core.h             |   15 -
>  drivers/target/Kconfig              |    1 +
>  drivers/target/Makefile             |    1 +
>  drivers/target/sbp/Kconfig          |   11 +
>  drivers/target/sbp/Makefile         |    1 +
>  drivers/target/sbp/sbp_target.c     | 2621 +++++++++++++++++++++++++++++++++++
>  drivers/target/sbp/sbp_target.h     |  251 ++++
>  include/linux/firewire.h            |   15 +
[...]

As noted in the changelogs:
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
-- 
Stefan Richter
-=====-===-- -=-= =-===
http://arcgraph.de/sr/
