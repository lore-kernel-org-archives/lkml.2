Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab2DZMCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:02:31 -0400
Received: from mx2.netapp.com ([216.240.18.37]:62043 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab2DZMC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:02:29 -0400
X-IronPort-AV: E=Sophos;i="4.75,486,1330934400"; 
   d="scan'208";a="643585029"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: kernel BUG at include/net/netns/generic.h:41
Thread-Topic: kernel BUG at include/net/netns/generic.h:41
Thread-Index: AQHNEPofLBggl9rQZUWE5n3mvfO03paISysAgASU6YCAAAEqgIAAAGMAgB/fvoCAAHzjAP//6DOg
Date: Thu, 26 Apr 2012 12:02:17 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA91A34FB@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120328002346.GB3077@redhat.com>
 <20120402172600.GA3728@redhat.com>
 <1333390230.13718.34.camel@lade.trondhjem.org>
 <4F7DC37F.7090404@parallels.com> <20120405161241.GA23658@redhat.com>
 <4F7DC4CC.9080502@parallels.com> <20120425225855.GA5537@redhat.com>
 <4F98EA72.6010300@parallels.com>
In-Reply-To: <4F98EA72.6010300@parallels.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3QC2evl013589

> -----Original Message-----
> From: Stanislav Kinsbursky [mailto:skinsbursky@parallels.com]
> Sent: Thursday, April 26, 2012 2:26 AM
> To: Dave Jones; Myklebust, Trond; Linux Kernel; netdev@vger.kernel.org
> Subject: Re: kernel BUG at include/net/netns/generic.h:41
> 
> 26.04.2012 02:58, Dave Jones Ğ½Ğ°Ğ¿Ğ¸ÑĞ°Ğ»:
> > On Thu, Apr 05, 2012 at 08:14:04PM +0400, Stanislav Kinsbursky wrote:
> >   >  05.04.2012 20:12, Dave Jones Ğ¿Ğ¸ÑˆĞµÑ‚:
> >   >  >  On Thu, Apr 05, 2012 at 08:08:31PM +0400, Stanislav Kinsbursky
> wrote:
> >   >  >
> >   >  >    >   So, there are few questions to you, Dave:
> >   >  >    >   1) can this happen (PipeFS mount attempt before SUNPRC
> module insertion has
> >   >  >    >   returned any value) in your case?
> >   >  >
> >   >  >  I don't know enough of what systemd is doing to answer this.
> >   >  >
> >   >  >    >   2) how often do you experience this problem? Not every boot, I
> suppose?
> >   >  >    >   3) And is it easy for you to reproduce?
> >   >  >
> >   >  >  It happens most the time, but not every time.
> >   >  >
> >   >
> >   >  Ok, I'll send the patch soon.
> >   >  Hope, it will help.
> >   >
> >   >  --
> >   >  Best regards,
> >   >  Stanislav Kinsbursky
> >
> > I didn't see a follow-up patch on this, and I'm still seeing the BUG in rc4.
> >
> > 	Dave
> 
> Dave, search for "SUNRPC: register PipeFS file system after pernet
> sybsystem" in your mail.
> You are in CC list.

Linus merged it last night together with the other NFS-related bugfixes...

Cheers
  Trond
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
