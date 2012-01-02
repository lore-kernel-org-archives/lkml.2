Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab2ABV0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:26:18 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:42727 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab2ABV0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:26:16 -0500
X-Sasl-enc: h5BnmTWridsf84AG9lJEbHyXVTSiCVSLKyyWR05fhoLP 1325539575
Message-ID: <4F0220F5.30309@fastmail.fm>
Date: Mon, 02 Jan 2012 21:26:13 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com> <20120102211904.GA15316@srcf.ucam.org>
In-Reply-To: <20120102211904.GA15316@srcf.ucam.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/12 21:19, Matthew Garrett wrote:
> On Mon, Jan 02, 2012 at 12:48:48PM -0800, Linus Torvalds wrote:
> 
>> Why are you guys making it any more complicated than that?
> 
> Because it's inadequate. You can't guarantee that we ever loaded 
> firmware. The same hardware might maintain state over warm reboots but 
> not over suspend. We never loaded the firmware loader driver. We never 
> called request_firmware(). We have no way of knowing whether the device 
> is an older one that needs firmware loading, or a newer one which has it 
> in flash.
> 

Can we tell by the USB ids that this is a device that might need
firmware and load it into memory anyway - it would use more memory but
would always work as we would have the firmware.

Thanks,

Jack
