Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2HIKON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:14:13 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:42548 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477Ab2HIKOL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:14:11 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Date: Thu, 9 Aug 2012 12:14:03 +0200
Subject: RE: [PATCHv2 1/4] modem_shm: Add Modem Access Framework
Thread-Topic: [PATCHv2 1/4] modem_shm: Add Modem Access Framework
Thread-Index: Ac11awVi8dUEYflmRQK4a2/SGTnYEgAqNq1wAADdIbA=
Message-ID: <F45880696056844FA6A73F415B568C695B0E797057@EXDCVYMBSTM006.EQ1STM.local>
References: <1344322471-3640-1-git-send-email-arun.murthy@stericsson.com>
 <1344322471-3640-2-git-send-email-arun.murthy@stericsson.com>
 <20120807183809.GC26990@kroah.com>
 <F45880696056844FA6A73F415B568C695B0E796A03@EXDCVYMBSTM006.EQ1STM.local>
 <20120808133748.GA14459@kroah.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Wed, Aug 08, 2012 at 05:36:05AM +0200, Arun MURTHY wrote:
> > > > On Tue, Aug 07, 2012 at 12:24:28PM +0530, Arun Murthy wrote:
> > > > > Adds Modem Access Framework, which allows for registering
> > > > > platform
> > > > specific
> > > > > modem access mechanisms. The framework also exposes APIs for
> > > > > client
> > > > drivers
> > > > > for getting and releasing access to modem, regardless of the
> > > > underlying
> > > > > platform specific access mechanism.
> > > >
> > > > The term "modems" here has a lot of legacy connotations.  First of
> > > > which is, userspace handles this today as tty devices, why aren't
> > > > you doing the same here?  Why does this have to be something
> > > > "special"?
> > > >
> > >
> > > The main focus over there the modem IPC.
> >
> > Over where?
> >
> > What "modem IPC"?
> >
> 
> I mean the dir which is added in this patch, "modem_shm" is added to have a
> separate list of such modem access drivers.

The modem that I am referring to is an on chip modem in embedded platforms.
Applications of these being mobile, tablets etc.
So the APE and modem resides on a single chip.

Thanks and Regards,
Arun R Murthy
------------------
