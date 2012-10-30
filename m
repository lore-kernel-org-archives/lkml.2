Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab2J3BxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 21:53:19 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:40056 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2J3BxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 21:53:18 -0400
Message-ID: <508F32A5.10000@ahsoftware.de>
Date: Tue, 30 Oct 2012 02:51:33 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: x86: Regression in 3.6.4, bisected to "Exclude E820_RESERVED
 regions..."
References: <508E58FD.2000707@ahsoftware.de> <508E8264.8070807@ahsoftware.de> <20121029165946.GB6614@kroah.com> <508EC69F.2030505@ahsoftware.de> <20121029183250.GB4623@kroah.com> <508EDEC6.7030101@ahsoftware.de> <20121029230146.GA22320@kroah.com>
In-Reply-To: <20121029230146.GA22320@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.10.2012 00:01, schrieb Greg Kroah-Hartman:

> Can you test out 3.6.5-rc1 and see if that works properly for you or
> not?  It should have all of the fixes in it already.

Just in time before I receive my new "memory layout" which might not 
have the problem with 3.6.4. ;)

3.6.5-rc1 booted just fine, thanks a lot.

Regards,

Alexander

