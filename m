Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1LATy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:54:58 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:26745 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1LATy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:54:57 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzzz2fh2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: RE: linux-next: manual merge of the staging tree with the hid tree
Thread-Topic: linux-next: manual merge of the staging tree with the hid tree
Thread-Index: AQHMr9szE9kf2yWHkEqPb1pfVBs60JXG31aA///jEECAASfQAP//e/2Q
Date: Thu, 1 Dec 2011 19:54:50 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA7B440@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <20111201143952.9aea929b16c7212570fc1bd2@canb.auug.org.au>
 <20111201035113.GA7647@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481AA7B139@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <alpine.LNX.2.00.1112012045540.18207@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1112012045540.18207@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jiri Kosina [mailto:jkosina@suse.cz]
> Sent: Thursday, December 01, 2011 2:46 PM
> To: KY Srinivasan
> Cc: Greg KH; Stephen Rothwell; linux-next@vger.kernel.org; linux-
> kernel@vger.kernel.org; Thomas Meyer
> Subject: RE: linux-next: manual merge of the staging tree with the hid tree
> 
> On Thu, 1 Dec 2011, KY Srinivasan wrote:
> 
> > > Ok, that's fine, Jiri, want me to just delete the driver from my tree
> > > now to remove any of these conflicts?
> >
> > Yesterday (Nov 30th, 2011) I had sent a patch for the mouse driver to
> > fix a bug that got introduced during the recent cleanup to exit staging.
> > This patch was against the staging tree that Greg is planning to delete.
> > It is a trivial patch; can you pick this up for the hid tree. If you
> > prefer, I could rebase the patch against your tree. Let me know.
> 
> I will pick the one you have sent against staging tree, no need for you to
> respin.

Thanks Jiri.

Regards,

K. Y


