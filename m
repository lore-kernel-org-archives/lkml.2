Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2HTTW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:22:28 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2385 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab2HTTWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:22:25 -0400
From: Rakesh Jain <Rakesh.Jain@imgtec.com>
To: Pete Delaney <piet.delaney@gmail.com>
CC: Marc Gauthier <marc@tensilica.com>, Chris Zankel <chris@zankel.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Kirill Krinkin <kirill.krinkin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "'Mahavir Prasad'" <er.mahavir@gmail.com>,
        Prasanna Rao <Prasanna.Rao@transwitch.com>,
        "Shimon Edelhaus" <Shimon.Edelhaus@transwitch.com>
Subject: RE: xtensa port maintenance
Thread-Topic: xtensa port maintenance
Thread-Index: AQHNd3xdpoBr8I1omUi+onrbsd09hJdc3fTQgAEcaACAAM95YA==
Date: Mon, 20 Aug 2012 19:17:49 +0000
Message-ID: <7E6CC3A7A7876F4BAC9F5E798E97262361F307@bamail01.ba.imgtec.org>
References: <50205592.1030205@gmail.com> <201208102115.59946.arnd@arndb.de>
 <50258D88.7090903@zankel.net> <5025975D.9030100@gmail.com>
 <522C1DF17AF50042AD8AE87F7887BD3D022DEE8CB5@exch.hq.tensilica.com>
 <7E6CC3A7A7876F4BAC9F5E798E9726235C5926@bamail01.ba.imgtec.org>
 <502DD7EE.1070903@gmail.com>
In-Reply-To: <502DD7EE.1070903@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.111.3]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-SEF-Processed: 7_3_0_01181__2012_08_20_20_21_51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Piet and Marc,
Skype does not provide source code for their app.
Skype provides libraries for embedded Linux platforms for ARM architecture such as TV widgets.
If my customer wants to provide Skype application for Xtensa platform, is there way to get Skype library for xtensa?
-Rakesh


-----Original Message-----
From: Pete Delaney [mailto:piet.delaney@gmail.com] 
Sent: Thursday, August 16, 2012 10:35 PM
To: Rakesh Jain
Cc: Marc Gauthier; Chris Zankel; Arnd Bergmann; linux-xtensa@linux-xtensa.org; Kirill Krinkin; Stephen Rothwell; Greg KH; linux-kernel@vger.kernel.org; Max Filippov; linux-next@vger.kernel.org; Andrew Morton; Linus Torvalds; 'Mahavir Prasad'; Prasanna Rao; Shimon Edelhaus
Subject: Re: xtensa port maintenance

On 08/16/2012 12:38 PM, Rakesh Jain wrote:
> Hi Marc,
> Is Skype library available for Xtensa Linux port?
> They are available for ARM.
I'd also like to know more about the Skype library.

-piet
> Thanks.
> -Rakesh
>
> -----Original Message-----
> From: Marc Gauthier [mailto:marc@tensilica.com]
> Sent: Friday, August 10, 2012 9:47 PM
> To: Pete Delaney; Chris Zankel; Arnd Bergmann; 
> linux-xtensa@linux-xtensa.org; Kirill Krinkin; Stephen Rothwell; Greg 
> KH; linux-kernel@vger.kernel.org; Max Filippov; 
> linux-next@vger.kernel.org; Andrew Morton; Linus Torvalds; 'Mahavir 
> Prasad'; Prasanna Rao; Shimon Edelhaus; Rakesh Jain
> Subject: Re: xtensa port maintenance
>
> Chris Zankel wrote:
>> I have set up a tree on github for now, and will work close with Max 
>> to get his changes to Stephen's linux-next tree and eventually Linus'
>> tree.
>> I think it's fine to add Max as a second maintainer [...]
> Thanks for helping!
>
>
> Pete Delaney wrote:
>> I'm afraid that doing it piecemeal has failed in the past
> Proper patches work fine, was just never done.
> (Can discuss off this To: list.)
>
>
>> Mind anding Marc and myself?
> Acting as maintainer involves submitting useful patches over some period of time.  Right now that's Max and Chris.
> (Love to do it, but have plenty as it is on my plate.)
>
> Thanks,
> -Marc
>


