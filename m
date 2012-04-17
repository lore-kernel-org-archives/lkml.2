Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2DQRai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:30:38 -0400
Received: from mail.wdtv.com ([66.118.69.84]:55860 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab2DQRah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:30:37 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for
Date: Tue, 17 Apr 2012 13:30:35 -0400
User-Agent: KMail/1.13.7 (Linux/3.2.14-pclos7-gene-pae-bfs; KDE/4.6.5; i686; ; )
Cc: Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        tigran@aivazian.fsnet.co.uk, hpa@zytor.com, x86@kernel.org
References: <20120411163849.GE4794@alberich.amd.com> <201204171153.04489.gene.heskett@gmail.com> <CAPXgP12_k4D-r=HQy3zidHhMP8ygMsT4J5Q+-h0CE3k_vpsazA@mail.gmail.com>
In-Reply-To: <CAPXgP12_k4D-r=HQy3zidHhMP8ygMsT4J5Q+-h0CE3k_vpsazA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 8bit
Message-Id: <201204171330.35470.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 17, 2012, Kay Sievers wrote:
>2012/4/17 Gene Heskett <gene.heskett@gmail.com>:
>> I do not think the above has anything to do with the current version
>> shipping in some distro's, which is trying to find the intel code on
>> kernels >2.6.39 when running on AMD stuff, so that script in
>> /etc/init.d needs attention too. Â I have nuked about half of that
>> script in my local copy so that it does install AMD code on AMD
>> processors. Â The errors I was seeing were only the lack of its
>> ability to find the Intel code and does not generate any output
>> resembling the above.
>
>Just a note: the intel microcode is loaded by a kernel-initiated
>firmware request these days. There is no (broken) init script on
>recent systems, to (rather mindlessly) fiddle around in userspace with
>kernel internals.
>
>Kay

That has to be a good deal in general, but it leaves us AMD users swinging 
in a strong breeze. That microcode loading was in the kernel until sometime 
in the 2.6.20ish time frame, I can recall scanning dmesg's where it was 
loaded by about line 75 in past history.  Now its just an afterthought. :(

Thanks Kay.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene>
The American nation in the sixth ward is a fine people; they love the
eagle -- on the back of a dollar.
		-- Finlay Peter Dunne
