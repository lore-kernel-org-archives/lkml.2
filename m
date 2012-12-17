Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab2LQVGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:06:38 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61617 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2LQVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:06:37 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'devendra.aaru'" <devendra.aaru@gmail.com>,
        "'Tantilov, Emil S'" <emil.s.tantilov@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <004101cddadb$b890e910$29b2bb30$@lucidpixels.com> <CAHdPZaOCKy8Ee17g-sU6YViGdfGPOsV7OLN+w+XA2eUWGmAy_Q@mail.gmail.com>
In-Reply-To: <CAHdPZaOCKy8Ee17g-sU6YViGdfGPOsV7OLN+w+XA2eUWGmAy_Q@mail.gmail.com>
Subject: RE: 3.6.10: Intel: ixgbe 0000:01:00.0 eth4: Detected Tx Unit Hang
Date: Mon, 17 Dec 2012 16:06:33 -0500
Message-ID: <018101cddc9a$65611d30$30235790$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQK8ra1auCvTpRS8/Na67XxLP9cuvAG+e5r5ljHlSRA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: devendra.aaru [mailto:devendra.aaru@gmail.com] 
Sent: Monday, December 17, 2012 1:39 PM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org
Subject: Re: 3.6.10: Intel: ixgbe 0000:01:00.0 eth4: Detected Tx Unit Hang

Ccing netdev
On Sat, Dec 15, 2012 at 10:49 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
wrote:
> Hello,
>
> Kernel 3.6.10, first time I have seen this that I can remember (on 10GbE)
> anyway, is this a known issue with 3.6.10?
>
> When the link went down is when I rebooted/etc the remote host attached on
> the other end.
> I've not changed anything physically with the hardware and have been on
> 3.6.0-3.6.9 and noticed this when I moved to 3.6.10.

--

> I don't believe we have seen Tx hangs in validation. If you could narrow
down the conditions that lead to the Tx hang that would help a lot. Also 
>  the output of ethtool -S eth4 after the Tx hang occurs can be useful to
get an idea of the load on the interface.

> Thanks,
> Emil

--

In this case I only have two servers that mount each other's NFS volumes and
that were idle at the time, I rebooted one of the systems and that is when I
saw this, if I can get something to repeat/pattern and/or the ethtool output
I will update this thread, thank you.

Justin.

