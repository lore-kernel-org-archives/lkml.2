Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2CDABL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 19:01:11 -0500
Received: from mta1.math.wisc.edu ([144.92.166.194]:35409 "EHLO
	mta1.math.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2CDABK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 19:01:10 -0500
Message-ID: <FD8CB954D8084F998E24C4558E41C627@hinkle>
From: "John G. Heim" <jheim@math.wisc.edu>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>
References: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle> <20120303173916.7eca9391@pyramind.ukuu.org.uk>
In-Reply-To: <20120303173916.7eca9391@pyramind.ukuu.org.uk>
Subject: Re: speakup bug
Date: Sat, 3 Mar 2012 18:01:07 -0600
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 15.4.3538.513
X-MimeOLE: Produced By Microsoft MimeOLE V15.4.3538.513
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox
Sent: Saturday, March 03, 2012 11:39 AM
>> Can anyone tell me how to fix this so it can be patched in the official
>> kernel code?
>
>The proper fix is to make the drivers work via the serial layer properly.

Well, I am not the worlds greatest C programmer but many years ago I wrote 
unix
device drivers for a living. Could a reasonably competent person have a
chance of fixing that?

> The speakup people have been told this repeatedly for years and years
> which is why their drivers work on less and less systems and won't run
> with things PCI or USB serial ports, and why they are forever buried in
> staging.

Do you recall if they gave a reason for not wanting to use the serial layer?
I don't even know what the serial layer is (although the name is descriptive
enough and I can guess).But I would think they'd have had some reason for
not wanting to do that.

