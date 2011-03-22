Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1CVWR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:17:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:36197 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1CVWRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:17:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,227,1299484800"; 
   d="scan'208";a="616436995"
Date: Tue, 22 Mar 2011 21:57:59 +0000
From: Alan Cox <alan@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Oren Weil <oren.jer.weil@intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, david@woodhou.se
Subject: Re: [PATCH 1/7] char/mei: PCI device and char driver support.
Message-ID: <20110322215759.2d982e06@bob.linux.org.uk>
In-Reply-To: <201103221822.43780.arnd@arndb.de>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
	<1300791092-14319-2-git-send-email-oren.jer.weil@intel.com>
	<201103221822.43780.arnd@arndb.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * In the PCI probe function, create a misc character device for
>   every instance you find behind each device. Remove the global
>   variables and constants.

The current code is complex and could be a ton simpler *but* don't
abuse misc devices when you have one per PCI instance please.

Alan (Miscdevice police)
