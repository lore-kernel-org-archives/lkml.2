Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2EAMQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 08:16:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:34057 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab2EAMQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 08:16:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="137404584"
Date: Tue, 1 May 2012 13:31:31 +0100
From: Alan Cox <alan@linux.intel.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: deadlock in vt_kbd_con_stop
Message-ID: <20120501133131.3271d69d@bob.linux.org.uk>
In-Reply-To: <4F9FBDD0.7050504@ladisch.de>
References: <4F9FBDD0.7050504@ladisch.de>
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

On Tue, 01 May 2012 12:41:20 +0200
Clemens Ladisch <clemens@ladisch.de> wrote:

> Pressing the Scroll Lock key in the console stops scrolling rather
> permanently. (Ctrl+S/Q works fine.)

Ok I see what is going on I think. Patch will follow very shortly.

Alan
