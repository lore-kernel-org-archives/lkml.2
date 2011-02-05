Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1BEDui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 22:50:38 -0500
Received: from nm4.bullet.mail.ac4.yahoo.com ([98.139.52.201]:41152 "HELO
	nm4.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753138Ab1BEDuh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 22:50:37 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Feb 2011 22:50:37 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 692057.72820.bm@omp1057.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2/Qu2UlxFn3tmzDC7JWJWCbhMMpjXzG9KT1BS5C1CERcSDZd+B2n+hXnrMGk9NPJoCYabAx8BUdcVWTurn0yAOEULiEQaxKMjETuz2wiuZQUo3I/yi/7FHZCi3vs11DODg24VsYauzX7dLrpH+c5FGTAUQuMTPbLY/pBLlyrJNE=;
Message-ID: <468686.3822.qm@web65716.mail.ac4.yahoo.com>
X-YMail-OSG: rsBQOZgVM1lApTp3wov7YKgy9CceKtixqpF1xWNAmP9qLBa
 oTKnIwLGGt.ApH84rJGKkcrzcfHiQsrggDnce2e76F1FQ1Qx4ka6NoadAw35
 9v3nfcyqtNejMbB95otJ8zXqZkhzenGma4orvjA1yNoq4UxghaCARRrG6nGu
 qrWAp3jRdpkBR80XqW7H9V9PKnKPjmzvhPLxODNAKh6.hy2_tkFYl7h_Q2cp
 b3SeQ94YDZXxAEi0jb57TvHhbiUYu5Qi1ZATEAireLfhqVcoNMBC71z0CJ8w
 2eUqmtc.iqiUb6btkEghoINTipkLxcSqa99yvcscPFXkFvj9hMWo.xwPcWrH
 ioDSoWvKbwercJntpvStUPhnNvA8z2FzoWyv7RNILYtwUK5jvq.QR
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Fri, 4 Feb 2011 19:45:11 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and _get_icount functions
To: Vadim Tsozik <vtsozik@optimum.net>, Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Pete Zaitcev <zaitcev@redhat.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110204193511.GA13617@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,
 Many thanks for your help with this,
  Vadim.

--- On Fri, 2/4/11, Greg KH <greg@kroah.com> wrote:

> From: Greg KH <greg@kroah.com>
> Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and _get_icount functions
> To: "Vadim Tsozik" <vtsozik@optimum.net>
> Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, "Pete Zaitcev" <zaitcev@redhat.com>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, "Vadim Tsozik" <tsozik@yahoo.com>
> Date: Friday, February 4, 2011, 2:35 PM
> On Wed, Jan 12, 2011 at 10:34:53PM
> -0500, Vadim Tsozik wrote:
> > Greg,
> > I apologize for the delay. Finally I managed to
> configure sendmail to relay messages via my ISP SMTP (Too
> bad, my ISP blocks port 25).
> > Below you can find patch generated off your 2.6.37-rc7
> usb branch. Please let me know if you have any problem to
> apply this.
> > Thank you in advance,
> 
> In the future, you need to create a patch that can be
> applied with '-p1'
> option from the root of the kernel tree, right now you
> created it at the
> root of the drivers/usb/ directory:
> 
> > --- usb/serial/mct_u232.c.orig   
> 2010-12-26 16:54:16.660294924 -0500
> > +++ usb/serial/mct_u232.c    2010-12-27
> 15:29:30.895141755 -0500
> 
> I edited it by hand and now applied it, sorry for the
> delay.
> 
> greg k-h
> 


      
