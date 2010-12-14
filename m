Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab0LNO5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:57:52 -0500
Received: from mail.digium.com ([216.207.245.2]:50962 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757754Ab0LNO5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:57:51 -0500
X-Greylist: delayed 1258 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Dec 2010 09:57:51 EST
Message-ID: <4D07806C.3070009@digium.com>
Date: Tue, 14 Dec 2010 08:34:20 -0600
From: Shaun Ruffell <sruffell@digium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Jouko Orava <jouko.orava@helsinki.fi>
CC: linux-kernel@vger.kernel.org
Subject: Re: Custom kernel logging using an USB microcontroller?
References: <alpine.LRH.2.00.1012130108200.12183@ruuvi.it.helsinki.fi>
In-Reply-To: <alpine.LRH.2.00.1012130108200.12183@ruuvi.it.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2010 05:31 PM, Jouko Orava wrote:
> Hello,
> 
> Would any of you happen to have written a kernel module for
> custom kernel logging to a USB microcontroller?

<snip>

> 
> So, any pointers to existing code I could adapt?
> Or hints on how the kernel-side logging via USB should be done?

Will netconsole (see Documentation/networking/netconsole.txt) work for
you?  Presumably you have a network adapter or can add a USB network
adapter.

Cheers,
Shaun
