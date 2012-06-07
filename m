Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248Ab2FGJGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:06:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:51817 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760189Ab2FGJGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:06:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108929937"
Date: Thu, 7 Jun 2012 10:22:28 +0100
From: Alan Cox <alan@linux.intel.com>
To: Richard Weinberger <richard@nod.at>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jslaby@suse.cz
Subject: Re: [uml-devel] um: TTY fixes (?)
Message-ID: <20120607102228.0ed8281e@bob.linux.org.uk>
In-Reply-To: <4FD06A22.6040002@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
	<4FCF6748.6020005@panasas.com>
	<4FD059AC.8050808@panasas.com>
	<4FD06A22.6040002@nod.at>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Breaking existing applications is a no-go, sorry.

Being insecure should also be a no-no.

Not sure what Jiri thinks but for the moment I think we need to push it
with a module option as to whether hangup on console is enabled or not.

I don't want to just break the existing user space, but leaving other
vendors systems insecure just to cover Fedora's backside is also not
entirely fair either.

Alan
