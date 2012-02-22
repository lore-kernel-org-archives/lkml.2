Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2BVWR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:17:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37115 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab2BVWR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:17:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 22 Feb 2012 23:17:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] firewire-sbp2: Various fixes
Message-ID: <20120222231716.7a7907fd@stein>
In-Reply-To: <1329317950-101579-1-git-send-email-bootc@bootc.net>
References: <1328881314-26544-1-git-send-email-bootc@bootc.net>
	<1329317950-101579-1-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15 Chris Boot wrote:
> In writing my SBP-2 target code I found a few areas in the firewire-sbp2
> initiator code that needed some attention:
> 
> 1. The Unit_Unique_ID property in SBP-2 unit directories is ignored, but this
>    should be used when working out the target port name instead of the node's
>    GUID if it is present. (Suggestion of Stefan Richter)
> 
> 2. The initiator tries to login to any and all SBP-2 targets, including ones on
>    the local node. This fails due to how the firewire stack / initiator code
>    works but is most likely undesirable behaviour, so this patch makes
>    firewire-sbp2 ignore SBP-2 targets on the local node.
> 
> 3. SBP-2 sends SCSI sense data over the wire in an unusual format which
>    requires un-mangling before we can pass it to the SCSI subsystem. Some of
>    this mangling is currently being done incorrectly, so this patch fixes it.

Thank you.  Pushed out to linux1394.git
-- 
Stefan Richter
-=====-===-- --=- =-==-
http://arcgraph.de/sr/
