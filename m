Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2LCX4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:56:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:26688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab2LCX4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:56:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,209,1355126400"; 
   d="scan'208";a="251352849"
Date: Mon, 3 Dec 2012 23:58:48 +0000
From: Alan Cox <alan@linux.intel.com>
To: "George Spelvin" <linux@horizon.com>
Cc: chris@the-brannons.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: Caps lock XOR on multiple keyboards?
Message-ID: <20121203235848.04228689@bob.linux.org.uk>
In-Reply-To: <20121203211911.20156.qmail@science.horizon.com>
References: <20121203211911.20156.qmail@science.horizon.com>
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

On 3 Dec 2012 16:19:11 -0500
"George Spelvin" <linux@horizon.com> wrote:

> (Not sure who owns this; Cc: to the last few people to touch
> drivers/tty/vt/keyboard.c.)

linux-input is probably the best place to discuss this
