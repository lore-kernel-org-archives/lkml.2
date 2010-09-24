Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0IXNxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:53:21 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:11385
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932243Ab0IXNxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:53:18 -0400
X-SpamScore: -31
X-BigFish: VS-31(zz1432N98dN1447Rzz1202hzz8275dh15d4Rz32i2a8h87h87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L997WA-02-7DF-02
X-M-MSG: 
Date: Fri, 24 Sep 2010 15:53:01 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Greg KH <gregkh@suse.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Erratum 383 fix for 32 bit x86 kernels
Message-ID: <20100924135300.GD9817@amd.com>
References: <20100924115239.GA9817@amd.com>
 <20100924134709.GA3132@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100924134709.GA3132@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 09:47:09AM -0400, Greg KH wrote:
> On Fri, Sep 24, 2010 at 01:52:40PM +0200, Joerg Roedel wrote:
> > Hi Greg,
> > 
> > here is a patch which I want to ask you to include into the current
> > -stable kernels.
> 
> For any stable-related stuff, please send it to stable@kernel.org so it
> doesn't get lost in my crazy inbox.
> 
> I'll take this this time, but in the future, please do this to ensure it
> gets in.

Ah ok, thanks for the hint. I will do this in the future, just forgot
this time.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

