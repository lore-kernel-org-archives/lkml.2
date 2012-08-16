Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab2HPTzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:55:44 -0400
Received: from multi.imgtec.com ([194.200.65.239]:15973 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab2HPTzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:55:39 -0400
X-Greylist: delayed 961 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2012 15:55:38 EDT
From: Rakesh Jain <Rakesh.Jain@imgtec.com>
To: Marc Gauthier <marc@tensilica.com>, Pete Delaney <piet.delaney@gmail.com>,
        Chris Zankel <chris@zankel.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "Kirill Krinkin" <kirill.krinkin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "'Mahavir Prasad'" <er.mahavir@gmail.com>,
        Prasanna Rao <Prasanna.Rao@transwitch.com>,
        Shimon Edelhaus <Shimon.Edelhaus@transwitch.com>
Subject: RE: xtensa port maintenance
Thread-Topic: xtensa port maintenance
Thread-Index: AQHNd3xdpoBr8I1omUi+onrbsd09hJdc3fTQ
Date: Thu, 16 Aug 2012 19:38:20 +0000
Message-ID: <7E6CC3A7A7876F4BAC9F5E798E9726235C5926@bamail01.ba.imgtec.org>
References: <50205592.1030205@gmail.com> <201208102115.59946.arnd@arndb.de>
 <50258D88.7090903@zankel.net> <5025975D.9030100@gmail.com>
 <522C1DF17AF50042AD8AE87F7887BD3D022DEE8CB5@exch.hq.tensilica.com>
In-Reply-To: <522C1DF17AF50042AD8AE87F7887BD3D022DEE8CB5@exch.hq.tensilica.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.111.3]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-SEF-Processed: 7_3_0_01181__2012_08_16_20_39_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,
Is Skype library available for Xtensa Linux port?
They are available for ARM.
Thanks.
-Rakesh

-----Original Message-----
From: Marc Gauthier [mailto:marc@tensilica.com] 
Sent: Friday, August 10, 2012 9:47 PM
To: Pete Delaney; Chris Zankel; Arnd Bergmann; linux-xtensa@linux-xtensa.org; Kirill Krinkin; Stephen Rothwell; Greg KH; linux-kernel@vger.kernel.org; Max Filippov; linux-next@vger.kernel.org; Andrew Morton; Linus Torvalds; 'Mahavir Prasad'; Prasanna Rao; Shimon Edelhaus; Rakesh Jain
Subject: Re: xtensa port maintenance

Chris Zankel wrote:
> I have set up a tree on github for now, and will work close with Max 
> to get his changes to Stephen's linux-next tree and eventually Linus' 
> tree.
> I think it's fine to add Max as a second maintainer [...]

Thanks for helping!


Pete Delaney wrote:
> I'm afraid that doing it piecemeal has failed in the past

Proper patches work fine, was just never done.
(Can discuss off this To: list.)


> Mind anding Marc and myself?

Acting as maintainer involves submitting useful patches over some period of time.  Right now that's Max and Chris.
(Love to do it, but have plenty as it is on my plate.)

Thanks,
-Marc

