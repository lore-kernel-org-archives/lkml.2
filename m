Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1ECRla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:41:30 -0400
Received: from mdc-mail-out01.ubisoft.com ([216.98.57.107]:52662 "EHLO
	mdc-mail-out01.ubisoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545Ab1ECRl3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:41:29 -0400
From: David Hill <david.hill@ubisoft.com>
To: Paul McEnery <pmcenery@gmail.com>
CC: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dgiagio@gmail.com" <dgiagio@gmail.com>,
        "dborca@yahoo.com" <dborca@yahoo.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date: Tue, 3 May 2011 13:41:27 -0400
Subject: RE: [PATCH] ipheth.c: Enable IP header alignment
Thread-Topic: [PATCH] ipheth.c: Enable IP header alignment
Thread-Index: AcwJuEmW4Ax/5ETJSBG0CfQViUhl5gAAQWpg
Message-ID: <710D4D6CE160654C87478D18385BB9971BE3FDCA5C@MDC-MAIL-CMS01.ubisoft.org>
References: <1304264799.2833.82.camel@localhost>
	<1304364912-15444-1-git-send-email-agimenez@sysvalve.es>
	<1304370274.2833.192.camel@localhost>
	<20110503165751.GA6566@bart.evergreen.loc>
	<710D4D6CE160654C87478D18385BB9971BE3FDCA46@MDC-MAIL-CMS01.ubisoft.org>
 <BANLkTi=W5HTLDa-UEvk4TefP3FyOvphxew@mail.gmail.com>
In-Reply-To: <BANLkTi=W5HTLDa-UEvk4TefP3FyOvphxew@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's not a problem, I can test it :)


-----Original Message-----
From: Paul McEnery [mailto:pmcenery@gmail.com] 
Sent: 3 mai 2011 13:34
To: David Hill
Cc: L. Alberto Giménez; Ben Hutchings; linux-kernel@vger.kernel.org; dgiagio@gmail.com; dborca@yahoo.com; davem@davemloft.net; open list:USB SUBSYSTEM; open list:NETWORKING DRIVERS
Subject: Re: [PATCH] ipheth.c: Enable IP header alignment

On 3 May 2011 18:18, David Hill <david.hill@ubisoft.com> wrote:
>
> Maybe I can help on this part.
>
> Git ?
>
> I'm using ubuntu natty ... The part  I'm not sure of is , do I patch ubuntu's kernel or I start from scratch?
>

If we can get the patch committed to the Github ipheth repo, I'll
package it in my Ubuntu PPA. You can then simply install ipheth-dkms
which allow it to replace the in-tree module for testing...

I unfortunately cannot test either, since I no longer have an iPhone.

Paul.
