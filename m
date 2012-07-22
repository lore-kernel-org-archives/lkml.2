Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2GVPJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 11:09:08 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:12373
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab2GVPJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 11:09:05 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I936eI542M1432Izz1202hzz8275dhz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: Olaf Hering <olaf@aepfle.de>, Greg KH <gregkh@linuxfoundation.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 00/13] drivers: hv: kvp
Thread-Topic: [PATCH 00/13] drivers: hv: kvp
Thread-Index: AQHNT/NB00SQsXjmDEmcq7JSjap8hpcFX8+AgADv8yCAAAVogIAFjrOAgAFErgCAAAhKEIAAA3+AgAAAZKCAAp6bAIAGMUUggAB1SYCAABj5oIAeNuMAgADJ0YA=
Date: Sun, 22 Jul 2012 15:08:52 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF923548B42@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <20120621224737.GA5933@kroah.com>
	 <426367E2313C2449837CD2DE46E7EAF9155EC47A@SN2PRD0310MB382.namprd03.prod.outlook.com>
	 <20120622132547.GA2639@kroah.com>
	 <426367E2313C2449837CD2DE46E7EAF9155ED14D@SN2PRD0310MB382.namprd03.prod.outlook.com>
	 <20120626213954.GA4840@kroah.com>
	 <426367E2313C2449837CD2DE46E7EAF9155ED64A@SN2PRD0310MB382.namprd03.prod.outlook.com>
	 <20120626222205.GA5948@kroah.com>
	 <426367E2313C2449837CD2DE46E7EAF9155ED68D@SN2PRD0310MB382.namprd03.prod.outlook.com>
	 <20120628142340.GA21537@aepfle.de>
	 <426367E2313C2449837CD2DE46E7EAF9155EF399@SN2PRD0310MB382.namprd03.prod.outlook.com>
	 <20120702195721.GE1894@decadent.org.uk>
	 <426367E2313C2449837CD2DE46E7EAF9155EF7C6@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <1342925458.11373.210.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1342925458.11373.210.camel@deadeye.wl.decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6MF9GRt032090



> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Saturday, July 21, 2012 10:51 PM
> To: KY Srinivasan
> Cc: Olaf Hering; Greg KH; apw@canonical.com; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH 00/13] drivers: hv: kvp
> 
> On Tue, 2012-07-03 at 15:24 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Ben Hutchings [mailto:ben@decadent.org.uk]
> > > Sent: Monday, July 02, 2012 3:57 PM
> > > To: KY Srinivasan
> > > Cc: Olaf Hering; Greg KH; apw@canonical.com; devel@linuxdriverproject.org;
> > > virtualization@lists.osdl.org; linux-kernel@vger.kernel.org;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH 00/13] drivers: hv: kvp
> > >
> > > On Mon, Jul 02, 2012 at 03:22:25PM +0000, KY Srinivasan wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Olaf Hering [mailto:olaf@aepfle.de]
> > > > > Sent: Thursday, June 28, 2012 10:24 AM
> > > > > To: KY Srinivasan
> > > > > Cc: Greg KH; apw@canonical.com; devel@linuxdriverproject.org;
> > > > > virtualization@lists.osdl.org; linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH 00/13] drivers: hv: kvp
> > > > >
> > > > > On Tue, Jun 26, KY Srinivasan wrote:
> > > > >
> > > > > > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > > > > > The fact that it was Red Hat specific was the main part, this should be
> > > > > > > done in a standard way, with standard tools, right?
> > > > > >
> > > > > > The reason I asked this question was to make sure I address these
> > > > > > issues in addition to whatever I am debugging now. I use the standard
> > > > > > tools and calls to retrieve all the IP configuration. As I look at
> > > > > > each distribution the files they keep persistent IP configuration
> > > > > > Information is different and that is the reason I chose to start with
> > > > > > RedHat. If there is a standard way to store the configuration, I will
> > > > > > do that.
> > > > >
> > > > >
> > > > > KY,
> > > > >
> > > > > instead of using system() in kvp_get_ipconfig_info and kvp_set_ip_info,
> > > > > wouldnt it be easier to call an external helper script which does all
> > > > > the distribution specific work? Just define some API to pass values to
> > > > > the script, and something to read values collected by the script back
> > > > > into the daemon.
> > > >
> > > > On the "Get" side I mostly use standard commands/APIs to get all the
> > > information:
> > > >
> > > > 1) IP address information and subnet mask: getifaddrs()
> > > > 2) DNS information:  Parsing /etc/resolv.conf
> > > > 3) /sbin/ip command for all the routing information
> > >
> > > If you're interested in the *current* configuration then (1) and (3)
> > > are OK but you should really use the rtnetlink API.
> > >
> > > However, I suspect that Hyper-V assumes that current and persistent
> > > configuration are the same thing, which is obviously not true in
> > > general on Linux.  But if NetworkManager is running then you can
> > > assume they are.
> >
> > I am only interested in the currently active information. Why do you
> > recommend the use of rtnetlink API over the "ip" command. If I am not
> > mistaken, the ip command uses netlink to get the information.
> [...]
> 
> 'Screen-scraping' the output of administrative tools is not good
> practice.  It may be the best you can do when writing a shell script,
> but for a C program it's generaly less reliable and often more difficult
> than using the underlying C API.

Ben,
Based on the input I have gotten, the consensus appears to be to have external
scripts to both GET and SET IP related configuration information. So, the KVP
daemon will need to parse information returned from these external distro specific
scripts (on the GET side).  While I agree with you that it is good to use C APIs, I currently
have the implementation using the "ip" command and it appears to be quite simple.
Furthermore, given that the information I need to pass back to the host needs to be
appropriately formatted (based on host specified format), I suspect using the "ip" command
may actually simplify the code.

Regards,

K. Y
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
