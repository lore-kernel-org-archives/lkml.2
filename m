Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2FEPNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:13:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35119 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2FEPNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:13:13 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Alessandro Rubini <rubini@gnudd.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC: "bhupesh.sharma@st.com" <bhupesh.sharma@st.com>,
        "federico.vaga@gmail.com" <federico.vaga@gmail.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "giancarlo.asnaghi@st.com" <giancarlo.asnaghi@st.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC] c_can_pci: generic module for c_can on PCI
Thread-Topic: [PATCH RFC] c_can_pci: generic module for c_can on PCI
Thread-Index: AQHNQlZvIR0fXNFzmEyfk5g9ye476pbp9EiAgAANzwCAALeXAIAAf5MAgAAdUICAAAKXgIAAAkwAgAACV4CAAHU20A==
Date: Tue, 5 Jun 2012 15:12:36 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9CB18A@DBDE01.ent.ti.com>
References: <4FCE07EE.40003@pengutronix.de>
  <D5ECB3C7A6F99444980976A8C6D896384FA5EC4DFC@EAPEX1MAIL1.st.com>
  <4FC135C6.5030206@grandegger.com> <1677842.Pq7naXsvrI@harkonnen>
  <D5ECB3C7A6F99444980976A8C6D896384FA5EC4B37@EAPEX1MAIL1.st.com>
  <3650428.HarNR9HfNF@harkonnen> <20120605131337.GA15432@mail.gnudd.com>
 <20120605133013.GA16108@mail.gnudd.com>
In-Reply-To: <20120605133013.GA16108@mail.gnudd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro/Federico,

On Tue, Jun 05, 2012 at 19:00:13, Alessandro Rubini wrote:
> > I personally like the "pci device sets up a platform device" idea.
> 
> Good. Than me or federico will submit a proposal. 
>  

I am late to the discussion, is there any specific reason to maintain a
separate platform file (c_can_pci.c). I think 90% of the code is copied
from c_can_paltform.c, code changes will be less if you merge to existing
c_can platform driver. You can look at D_CAN integration to C_CAN driver.

[1] https://gitorious.org/linux-can/linux-can-next

Regards
AnilKumar