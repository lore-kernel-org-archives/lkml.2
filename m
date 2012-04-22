Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2DVDGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 23:06:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40668 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab2DVDGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 23:06:21 -0400
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Apr 2012 23:06:21 EDT
X-Sasl-enc: Lo4bHJqnmHPaCznHZJTT5VG5dsNXbe4ZxFwd1mVEIXGM 1335063336
Date: Sat, 21 Apr 2012 23:55:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay@vrfy.org>
Cc: Gene Heskett <gene.heskett@gmail.com>, Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        tigran@aivazian.fsnet.co.uk, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 2/2] x86, microcode: Ensure that module is only loaded
 for
Message-ID: <20120422025532.GA19064@khazad-dum.debian.net>
References: <20120411163849.GE4794@alberich.amd.com>
 <4F8D7A0A.4080404@linux.vnet.ibm.com>
 <20120417145002.GA11221@aftab>
 <201204171153.04489.gene.heskett@gmail.com>
 <CAPXgP12_k4D-r=HQy3zidHhMP8ygMsT4J5Q+-h0CE3k_vpsazA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP12_k4D-r=HQy3zidHhMP8ygMsT4J5Q+-h0CE3k_vpsazA@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012, Kay Sievers wrote:
> 2012/4/17 Gene Heskett <gene.heskett@gmail.com>:
> > I do not think the above has anything to do with the current version
> > shipping in some distro's, which is trying to find the intel code on
> > kernels >2.6.39 when running on AMD stuff, so that script in /etc/init.d
> > needs attention too.  I have nuked about half of that script in my local
> > copy so that it does install AMD code on AMD processors.  The errors I was
> > seeing were only the lack of its ability to find the Intel code and does
> > not generate any output resembling the above.
> 
> Just a note: the intel microcode is loaded by a kernel-initiated
> firmware request these days. There is no (broken) init script on

Is it?  Which distros have deployed the required userspace and switched to
Intel binary microcode already?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
