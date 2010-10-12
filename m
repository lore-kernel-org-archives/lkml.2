Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0JLSFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:05:12 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30683 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0JLSFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:05:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6134"; a="57628619"
Message-ID: <50cefd84a7623992aaa547f1476a67d4.squirrel@www.codeaurora.org>
In-Reply-To: <Pine.LNX.4.44L0.1010120953070.1705-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1010120953070.1705-100000@iolanthe.rowland.org>
Date: Tue, 12 Oct 2010 11:07:04 -0700 (PDT)
Subject: Re: [RFC/PATCH 2/2] usb: Adding SuperSpeed support to dummy_hcd
From: tlinder@codeaurora.org
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Brokhman Tatyana" <tlinder@codeaurora.org>, linux-usb@vger.kernel.org,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 12 Oct 2010, Brokhman Tatyana wrote:

Hi Alan

I see your point. I'll update this in the next patch.

Thanks
Tanya

>> Hi Alan
>>
>> Thanks you for your comments. Please see my reply inline.
>
>> > In addition, I suspect the dummy_hcd driver structure shouldn't
>> contain
>> > an address_device entry.  It should be present only in dummy_ss_hcd.
>>
>> I'm not sure I follow...
>> According to the code and comments in hub.c address_device cb is used if
>> the host controller wishes to choose the device address itself instead
>> of
>> the address chosen by the core.
>
> Correct.
>
>>  It seems to me that there is nothing
>> preventing the dummy_hcd from supplying such cb as well. Is there?
>> Having both HS and SS dummy_hcd determine the device address seems more
>> convenient for testing proposes.
>
> For testing purposes, it is best to imitate the behavior of a real
> device as closely as possible.  USB-2.0 host controllers do not assign
> their own addresses to devices; they use the addresses provided by
> usbcore.  I think this is also true for the low/full/high-speed
> components of a USB-3.0 controller.
>
> Alan Stern
>
>


