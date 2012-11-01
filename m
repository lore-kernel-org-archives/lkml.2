Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab2KAUtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:49:35 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41624 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2KAUtd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 1 Nov 2012 16:49:33 -0400
Message-Id: <5092E058020000780008EBA2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 01 Nov 2012 20:49:28 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>
Cc: <sfr@canb.auug.org.au>, <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 31 (ehci, dbgp)
References: <5092D1AC020000780008EB60@nat28.tlf.novell.com>
 <Pine.LNX.4.44L0.1211011636410.1762-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1211011636410.1762-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Alan Stern <stern@rowland.harvard.edu> 11/01/12 9:39 PM >>>
>On Thu, 1 Nov 2012, Jan Beulich wrote:
>> >>> Alan Stern <stern@rowland.harvard.edu> 11/01/12 4:28 PM >>>
>> >Evidently we need to change your new test in
>> >drivers/usb/early/ehci-dbgp.c to:
>> >
>> >#if IS_ENABLED(CONFIG_USB_HCD_EHCI) || defined(CONFIG_USB_CHIPIDEA_HOST)
>> >
>> >Upcoming changes to ehci-hcd will make this unnecessary in 3.8, but for 
>> >now we need it.
>> 
>> Which tells me that the CONFIG_USB_SUPPORT version would have been
>> the better one  (and I would favor that over the ugly variant you suggest
>> above).
>
>I also suggested IS_ENABLED(CONFIG_USB), which is no uglier than what 
>you submitted and would also fix this build error.  How about using it 
>instead?

Yes, that's better. Question then is - updated original patch or incremental one?

Jan

