Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2LDIv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:51:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:51164 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab2LDIvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:51:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,213,1355126400"; 
   d="scan'208";a="251563721"
Date: Tue, 4 Dec 2012 08:54:26 +0000
From: Alan Cox <alan@linux.intel.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 0/9] tty: Fix buffer work access-after-free
Message-ID: <20121204085426.389ca79b@bob.linux.org.uk>
In-Reply-To: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
References: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2012 02:07:36 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> This patch series addresses the causes of flush_to_ldisc accessing
> the tty after freeing.

Looks good to me. Would be nice to keep a copy of the test that shows
it up in the comments of the patches somewhere.
