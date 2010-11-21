Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0KUVOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 16:14:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50924
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab0KUVO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 16:14:28 -0500
Date: Sun, 21 Nov 2010 13:14:53 -0800 (PST)
Message-Id: <20101121.131453.48488717.davem@davemloft.net>
To: tony.luck@intel.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com
Subject: Re: [RFC] persistent store
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
References: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>
Date: Sat, 20 Nov 2010 15:48:19 -0800

> The usage model I'm envisioning is that a platform driver
> will register with this code to provide the actual storage.
> I've tried to make this interface general, but I'm working
> from a sample of one (the ACPI ERST code), so if anyone else
> has some persistent store that can't be handled by this code,
> speak up and we can put in the necessary tweaks.
> 
> My assumptions are that the data that Linux cares about will
> be wrapped in some error record structure with a header, and
> possibly a footer that the device code needs. So the driver
> specifies how much padding to put around a buffer to make
> life easy for it.  It also specifies the maximum number of
> bytes that can be saved in one record.

Thanks for doing this work Tony.

On sparc64 I can mark an arbitrary region of physical memory
as persistent across soft reboots.  So I'll likely use that
to implement these interfaces.
