Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761Ab2FDPCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:02:32 -0400
Received: from antcom.de ([188.40.178.216]:37000 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab2FDPCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:02:31 -0400
Message-ID: <4FCCCE04.3000904@antcom.de>
Date: Mon, 04 Jun 2012 17:02:28 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] ohci-nxp: Use ohci_finish_controller_resume()
References: <Pine.LNX.4.44L0.1206041027420.1555-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1206041027420.1555-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 06/04/2012 04:29 PM, Alan Stern wrote:
>> OHCI drivers are supposed to use ohci_finish_controller_resume(). This patch
>> adds respective suspend and resume code to ohci-nxp. The following compiler
>> warning is fixed this way:
>>
>> drivers/usb/host/ohci-hub.c:321: warning: 'ohci_finish_controller_resume'
>> defined but not used
> 
> This is not a correct description of the patch.  A correct description 
> would be something like:
> 
> 	Add suspend/resume support to the ohci-nxp driver.
> 
> The compiler warning needs a completely different fix; 
> ohci_finish_controller_resume should be given a __maybe_unused 
> annotation.

Thanks for the suggestion! I'll rather do the latter.

Roland
