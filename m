Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab0JLP4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:56:31 -0400
Received: from kroah.org ([198.145.64.141]:52626 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab0JLP43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:56:29 -0400
Date: Tue, 12 Oct 2010 08:54:26 -0700
From: Greg KH <greg@kroah.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Bernhard Walle <walle@corscience.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: octeon: Add Lanai board USB clock type
Message-ID: <20101012155426.GA15238@kroah.com>
References: <1286791747-3151-1-git-send-email-walle@corscience.de> <4CB340F1.8020000@caviumnetworks.com> <4CB343DC.3050506@corscience.de> <4CB345C1.80709@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB345C1.80709@caviumnetworks.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 10:13:37AM -0700, David Daney wrote:
> On 10/11/2010 10:05 AM, Bernhard Walle wrote:
>> Am 11.10.2010 18:53, schrieb David Daney:
>>> On 10/11/2010 03:09 AM, Bernhard Walle wrote:
>>>> Add the LANAI2 board to __cvmx_helper_board_usb_get_clock_type(). It
>>>> also uses the USB_CLOCK_TYPE_CRYSTAL_12 clock.
>>>>
>>>> Signed-off-by: Bernhard Walle<walle@corscience.de>
>>>> ---
>>>>    drivers/staging/octeon/cvmx-helper-board.c |    1 +
>>>>    1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> NAK.
>>>
>>> We don't currently support USB, so churning up this file doesn't help
>>> anything.
>>
>> Well, agreed, but why not removing that code entirely then?
>>
>
> That is the eventual plan.

Why not do that now?

Or add USB support to the driver, but don't leave it in the in-kernel
driver and expect users to know that this is something they shouldn't be
doing.

Also, why aren't you going to support the USB devices?  What's wrong
with that?

thanks,

greg k-h
