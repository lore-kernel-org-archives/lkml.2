Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2EVUEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:04:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:22152 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2EVUEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:04:42 -0400
X-IronPort-AV: E=Sophos;i="4.75,640,1330923600"; 
   d="scan'208";a="196081411"
From: Simon Graham <simon.graham@citrix.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adnan Misherfi <adnan.misherfi@oracle.com>
Date: Tue, 22 May 2012 16:03:22 -0400
Subject: RE: [PATCH] xen/netback: calculate correctly the SKB slots.
Thread-Topic: [PATCH] xen/netback: calculate correctly the SKB slots.
Thread-Index: Ac04UR7Us5DWyIPJQzKGsXSNCB5BEQABL6/g
Message-ID: <F02ED76F3FCF8C468AD22A7618C05BBBB18DBFFEA4@FTLPMAILBOX01.citrite.net>
References: <1337621793-12486-1-git-send-email-konrad.wilk@oracle.com>
	 <1337627640.2979.33.camel@bwh-desktop.uk.solarflarecom.com>
	 <1337678512.10118.40.camel@zakaz.uk.xensource.com>
	 <20120522180901.GC22488@phenom.dumpdata.com>
	 <F02ED76F3FCF8C468AD22A7618C05BBBB18DBFFE61@FTLPMAILBOX01.citrite.net>
 <1337714930.3991.1.camel@dagon.hellion.org.uk>
In-Reply-To: <1337714930.3991.1.camel@dagon.hellion.org.uk>
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

> 
> That sounds very plausible indeed!
> 
> Please can format this as a commit message and resend with a
> Signed-off-by.
> 

Will do
Simon

> many thanks,
> Ian.
> 
> >
> > We found this running with a VIF bridged to a USB 3G Modem where
> > skb->data started near the end of a page so the header would always
> > span the page boundary.
> >
> > It was very easy to get the VIF to stop processing frames with the old
> > code and we have not seen any problems since applying this patch.
> >
> > Simon
> >
> 

