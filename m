Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2DQSHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:07:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43133 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2DQSHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:07:48 -0400
Date: Tue, 17 Apr 2012 20:07:33 +0200
From: Borislav Petkov <bp@amd64.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Kay Sievers <kay@vrfy.org>, Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        tigran@aivazian.fsnet.co.uk, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for
Message-ID: <20120417180733.GA13989@aftab>
References: <20120411163849.GE4794@alberich.amd.com>
 <201204171153.04489.gene.heskett@gmail.com>
 <CAPXgP12_k4D-r=HQy3zidHhMP8ygMsT4J5Q+-h0CE3k_vpsazA@mail.gmail.com>
 <201204171330.35470.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201204171330.35470.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 01:30:35PM -0400, Gene Heskett wrote:
> On Tuesday, April 17, 2012, Kay Sievers wrote:
> >2012/4/17 Gene Heskett <gene.heskett@gmail.com>:
> >> I do not think the above has anything to do with the current version
> >> shipping in some distro's, which is trying to find the intel code on
> >> kernels >2.6.39 when running on AMD stuff, so that script in
> >> /etc/init.d needs attention too. آ I have nuked about half of that
> >> script in my local copy so that it does install AMD code on AMD
> >> processors. آ The errors I was seeing were only the lack of its
> >> ability to find the Intel code and does not generate any output
> >> resembling the above.
> >
> >Just a note: the intel microcode is loaded by a kernel-initiated
> >firmware request these days. There is no (broken) init script on
> >recent systems, to (rather mindlessly) fiddle around in userspace with
> >kernel internals.
> >
> >Kay
> 
> That has to be a good deal in general, but it leaves us AMD users swinging 
> in a strong breeze. That microcode loading was in the kernel until sometime 
> in the 2.6.20ish time frame, I can recall scanning dmesg's where it was 
> loaded by about line 75 in past history.  Now its just an afterthought. :(

Well, I don't know what your script does but it should simply

$ modprobe microcode

and the module should figure it out itself which microcode to load,
AFAICT. 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
