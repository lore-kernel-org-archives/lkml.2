Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab0JYT57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:57:59 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:48775 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab0JYT55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:57:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Message-id: <4CC5E131.9040408@nolaviz.org>
Date: Mon, 25 Oct 2010 21:57:37 +0200
From: Alon Ziv <alon@nolaviz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14)
 Gecko/20101006 Lightning/1.0b1 Thunderbird/3.0.9
To: Johan Hovold <jhovold@gmail.com>
Cc: Alon Ziv <alon+git@nolaviz.org>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Export usb_serial_generic_write_room for use in
 modules
References: <1287859409-13810-1-git-send-email-alon-git@nolaviz.org>
 <1287859409-13810-2-git-send-email-alon-git@nolaviz.org>
 <20101025112043.GB4046@localhost>
In-reply-to: <20101025112043.GB4046@localhost>
X-Enigmail-Version: 1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On 10/25/2010 01:20 PM, you wrote:
>> Any module using usb_serial_generic_write (which is already exported)
>> had better use usb_serial_generic_write_room as well, or be prepared
>> for failures.
>
> As I mentioned elsewhere, this description is a little misleading as any
> driver can use the generic write_room implementation simply by not
> overriding it (i.e. leaving the write_room field undefined).
>
> There is nothing wrong with exporting it, but it is currently only your
> other patch that requires that. Could you perhaps just modify the patch
> description?
>
Well... the latest changes (due to your review) removed even my driver's
use of this function. So probably there is no need to export it (at
least not yet).

If you prefer that I leave the export in place (and unused), I will
clarify the patch description.

-az
