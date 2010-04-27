Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0D0Sfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:35:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57349 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab0D0Sfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=MxFFiiO69BfhG9+BQVPLP7YSIJ6ICUWfr5w4cGs7eeT3fOPnq77NzFrs88h4gP/Vgt
         s3ckQ1uy4cneiQgDdx8g8J8NGRC6wtgghVIv3VkMtMhHmbfavr3mD1/xVPccNJzTvN+T
         NNhKWfJ9lMfeWmNnwitYe4kycgtUWYsY8Lr4Q=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: David Miller <davem@davemloft.net>
Subject: Re: 2.6.34-rc5+: oops in IPv6
Date: Tue, 27 Apr 2010 20:35:37 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc5; KDE/4.3.4; i686; ; )
Cc: manuel.lauss@googlemail.com, linux-kernel@vger.kernel.org
References: <z2if861ec6f1004250745u94892bdbw9b17db4be57b131b@mail.gmail.com> <201004262058.24465.maciej.rutecki@gmail.com> <20100426.120200.179935218.davem@davemloft.net>
In-Reply-To: <20100426.120200.179935218.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004272035.37602.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 26 kwietnia 2010 o 21:02:00 David Miller wrote:
> From: Maciej Rutecki <maciej.rutecki@gmail.com>
> Date: Mon, 26 Apr 2010 20:58:24 +0200
> 
> > On niedziela, 25 kwietnia 2010 o 16:45:41 Manuel Lauss wrote:
> >> 2.6.34-rc5-00204-gddc9b34  dies when sshd (openssh 5.5) is started
> >> Last pull I made on April 23 was fine.
> >>
> >> (transcribed from a photo):
> >>
> >> BUG: unable to handle kernel NULL pointer dereference at 00000004
> >> IP: [<b1535b72>] inet6_csk_bind_conflict+0x6e/0xb0
> >
> > I created a Bugzilla entry at
> > https://bugzilla.kernel.org/show_bug.cgi?id=15857
> > for your bug report, please add your address to the CC list in there,
> > thanks!
> 
> It's fixed in Linus's tree like an hour after he reported this.
> 

Thanks for information. Closed.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
