Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab1KYN6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 08:58:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53345 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab1KYN6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 08:58:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 1/2] MISC: convert drivers/misc/* to use module_i2c_driver()
Date: Fri, 25 Nov 2011 13:58:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Anantha Narayanan <Anantha.Narayanan@intel.com>,
        Samu Onkalo <samu.p.onkalo@nokia.com>, Hemanth V <hemanthv@ti.com>,
        Christoph Mair <christoph.mair@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Gardner <bgardner@wabtec.com>, Minkyu Kang <mk7.kang@samsung.com>,
        Kalhan Trisal <kalhan.trisal@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>, Daniel Mack <zonque@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        "Greg Kroah-Hartman" <greg@kroah.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Anatolij Gustschin <agust@denx.de>
References: <1322194447.30842.0.camel@phoenix> <201111251015.43439.arnd@arndb.de> <4ECF70BB.2080904@metafoo.de>
In-Reply-To: <4ECF70BB.2080904@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251358.19779.arnd@arndb.de>
X-Provags-ID: V02:K0:C8LFenwho5gwO1Lpw6xCrX3qJ8j3PnZUaTQsFMZJzbu
 N+vRMPHTIHr3or9OffNh4TN0vuZiKwT4L2SrxkDGLc6Gt1IBa2
 gDuMnpnAbi9gMNe6e1nGCpxOknywoHmVwzxovqA18ZWeSoOcvB
 PtMr6yXuCA/d0A6jVQ2vziAn31DpOCsZzaFaN/uwTBk2MC+hWh
 Gviej5eCQWfQOiTP7TOLiBsqWFV5pY3ytpkdb8kcPyWKxSpjLp
 +jMcMUlVPNaQH3BhaT/BDr2kgpDmZpt6Xz+QTu9CCIyz8+ZnRc
 VsjBfMyoZHCKNhDgKMF5OSqz6QR4C5gR8qUuPDlE8G/+/obQjq
 u8yfN8Jv/Spg74vyw3C0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 November 2011, Lars-Peter Clausen wrote:
> > Obviously it can only go in after the patches introducing the macros.
> > Since Greg owns both the char-misc and driver-core trees, there should
> > be no problem coordinating between the two.
> > 
> Yes, but a similar patch has been send out for of a bunch of other trees.
> And the commit message does not state that there is a dependency on not yet
> applied patches and neither where to get them.

Yes, good point. That should probably be mentioned so people don't just
apply the patches and find out the hard way that they don't work.

	Arnd
