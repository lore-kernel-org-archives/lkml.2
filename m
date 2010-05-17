Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0EQKIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:08:25 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:18945 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0EQKIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:08:23 -0400
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohavlCkce+Ub5QXMSOpHp3LrAPgFm1SZs=
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]460EX on-chip SATA driver <Kernel 2.6.33> < resubmission >
Date: Mon, 17 May 2010 12:06:47 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32.11-sr; KDE/4.4.2; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Rupjyoti Sarmah <rsarmah@amcc.com>,
       linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org
References: <201005051757.o45HvPmY005954@amcc.com> <4BED8BF1.5080800@ru.mvista.com> <1273966828.21352.670.camel@pasglop>
In-Reply-To: <1273966828.21352.670.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005171206.47566.sr@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Sunday 16 May 2010 01:40:28 Benjamin Herrenschmidt wrote:
> > > +		SATA0: sata@bffd1000 {
> > > +                        compatible = "amcc,sata-460ex";
> > > +			reg = <4 0xbffd1000 0x800 4 0xbffd0800 0x400>;
> > > +                        interrupt-parent = <&UIC3>;
> > > +                        interrupts = <0x0 0x4       /* SATA */
> > > +                                      0x5 0x4>;     /* AHBDMA */
> > > +                };
> > > +
> > > 
> > >  		POB0: opb {
> > >  		
> > >  			compatible = "ibm,opb-460ex", "ibm,opb";
> > >  			#address-cells = <1>;
> >    
> >    Please put the device tree update in a separate patch to go thru the
> > 
> > PowerPC tree.
> 
> Additionally, the boot wrapper should probably either remove the node or
> at least use a status property "ok" / "disabled" to represent whether
> the board is configured for SATA or PCIe x1...

U-Boot already sets the "status" property of the PCIe or SATA node 
accordingly. Just let me know if this doesn't work for you.

Cheers,
Stefan
