Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2HOMkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:40:16 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:16339
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172Ab2HOMkN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:40:13 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -18
X-BigFish: VS-18(zz98dI9371I13ddR542M1432Izz1202hzz8275bh8275dhz2fh2a8h683h839h944hd25hf0ah107ah1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Greg KH <gregkh@linuxfoundation.org>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH V2 02/18] Drivers: hv: Add KVP definitions for IP
 address injection
Thread-Topic: [PATCH V2 02/18] Drivers: hv: Add KVP definitions for IP
 address injection
Thread-Index: AQHNeXQwVqOoL7QwhkKLjgxvXqp5WpdYiAmAgAAS5pCAAjeJoA==
Date: Wed, 15 Aug 2012 12:39:55 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236C0FA1@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1344877584-21738-1-git-send-email-kys@microsoft.com>
 <1344877627-21779-1-git-send-email-kys@microsoft.com>
 <1344877627-21779-2-git-send-email-kys@microsoft.com>
 <20120814013815.GA29829@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9236BF8D0@SN2PRD0310MB382.namprd03.prod.outlook.com>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9236BF8D0@SN2PRD0310MB382.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel-bounces@linuxdriverproject.org [mailto:devel-
> bounces@linuxdriverproject.org] On Behalf Of KY Srinivasan
> Sent: Monday, August 13, 2012 10:57 PM
> To: Greg KH
> Cc: olaf@aepfle.de; linux-kernel@vger.kernel.org; virtualization@lists.osdl.org;
> apw@canonical.com; devel@linuxdriverproject.org; ben@decadent.org.uk
> Subject: RE: [PATCH V2 02/18] Drivers: hv: Add KVP definitions for IP address
> injection
> 
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Monday, August 13, 2012 9:38 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org; olaf@aepfle.de; apw@canonical.com;
> > ben@decadent.org.uk
> > Subject: Re: [PATCH V2 02/18] Drivers: hv: Add KVP definitions for IP address
> > injection
> >
> > On Mon, Aug 13, 2012 at 10:06:51AM -0700, K. Y. Srinivasan wrote:
> > > Add the necessary definitions for supporting the IP injection functionality.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > Reviewed-by: Olaf Hering <olaf@aepfle.de>
> > > Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
> > > ---
> > >  drivers/hv/hv_util.c     |    4 +-
> > >  include/linux/hyperv.h   |   76
> > ++++++++++++++++++++++++++++++++++++++++++++-
> > >  tools/hv/hv_kvp_daemon.c |    2 +-
> > >  3 files changed, 77 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> > > index d3ac6a4..a0667de 100644
> > > --- a/drivers/hv/hv_util.c
> > > +++ b/drivers/hv/hv_util.c
> > > @@ -263,7 +263,7 @@ static int util_probe(struct hv_device *dev,
> > >  		(struct hv_util_service *)dev_id->driver_data;
> > >  	int ret;
> > >
> > > -	srv->recv_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> > > +	srv->recv_buffer = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
> > >  	if (!srv->recv_buffer)
> > >  		return -ENOMEM;
> > >  	if (srv->util_init) {
> > > @@ -274,7 +274,7 @@ static int util_probe(struct hv_device *dev,
> > >  		}
> > >  	}
> > >
> > > -	ret = vmbus_open(dev->channel, 2 * PAGE_SIZE, 2 * PAGE_SIZE, NULL,
> > 0,
> > > +	ret = vmbus_open(dev->channel, 4 * PAGE_SIZE, 4 * PAGE_SIZE, NULL,
> > 0,
> > >  			srv->util_cb, dev->channel);
> > >  	if (ret)
> > >  		goto error;
> > > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> > > index 68ed7f7..11afc4e 100644
> > > --- a/include/linux/hyperv.h
> > > +++ b/include/linux/hyperv.h
> > > @@ -122,12 +122,53 @@
> > >  #define REG_U32 4
> > >  #define REG_U64 8
> > >
> > > +/*
> > > + * As we look at expanding the KVP functionality to include
> > > + * IP injection functionality, we need to maintain binary
> > > + * compatibility with older daemons.
> > > + *
> > > + * The KVP opcodes are defined by the host and it was unfortunate
> > > + * that I chose to treat the registration operation as part of the
> > > + * KVP operations defined by the host.
> > > + * Here is the level of compatibility
> > > + * (between the user level daemon and the kernel KVP driver) that we
> > > + * will implement:
> > > + *
> > > + * An older daemon will always be supported on a newer driver.
> > > + * A given user level daemon will require a minimal version of the
> > > + * kernel driver.
> > > + * If we cannot handle the version differences, we will fail gracefully
> > > + * (this can happen when we have a user level daemon that is more
> > > + * advanced than the KVP driver.
> > > + *
> > > + * We will use values used in this handshake for determining if we have
> > > + * workable user level daemon and the kernel driver. We begin by taking the
> > > + * registration opcode out of the KVP opcode namespace. We will however,
> > > + * maintain compatibility with the existing user-level daemon code.
> > > + */
> > > +
> > > +/*
> > > + * Daemon code not supporting IP injection (legacy daemon).
> > > + */
> > > +
> > > +#define KVP_OP_REGISTER	4
> >
> > Huh?
> >
> > > +/*
> > > + * Daemon code supporting IP injection.
> > > + * The KVP opcode field is used to communicate the
> > > + * registration information; so define a namespace that
> > > + * will be distinct from the host defined KVP opcode.
> > > + */
> > > +
> > > +#define KVP_OP_REGISTER1 100
> > > +
> > >  enum hv_kvp_exchg_op {
> > >  	KVP_OP_GET = 0,
> > >  	KVP_OP_SET,
> > >  	KVP_OP_DELETE,
> > >  	KVP_OP_ENUMERATE,
> > > -	KVP_OP_REGISTER,
> > > +	KVP_OP_GET_IP_INFO,
> > > +	KVP_OP_SET_IP_INFO,
> >
> > So you overloaded the command and somehow think that is ok?  How is that
> > supposed to work?  Why not just always keep it there, but fail if it is
> > called as you know you have a mismatch?
> >
> > Otherwise, again, you just broke older tools on a newer kernel.
> >
> > Or am I missing something here?
> 
> Greg,
> 
> The registration operation occurs when the daemon first starts up. I should have
> established
> a distinct namespace for the daemon versions that would not overlap with the
> host
> defined KVP operations initially. Unfortunately when I first implemented KVP, I
> did not know
> about the new KVP verbs and so selected a value that ended up colliding with the
> new KVP
> operations. To maintain compatibility with older daemons, I have to support this
> old registration
> value, which is what you are seeing here. Since the initial driver/daemon
> handshake phase does
> not overlap with the normal functioning of the KVP stack, we can use the old
> daemon
> registration value to distinguish that the daemon does not support IP injection.
> The current
> implementation does support a compatible environment for older daemons.
> 

Greg,

I hope this explanation is satisfactory. If there are other issues that you would
want me to address before this patch set can be accepted, let me know and I will
address them right away.

Regards,

K. Y 


