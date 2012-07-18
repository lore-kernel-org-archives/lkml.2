Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2GRNOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:14:55 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:55884
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681Ab2GRNOv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:14:51 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz9371I542M1432Izz1202hzz8275bhz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.244.37;KIP:(null);UIP:(null);(null);H:CH1PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 07/17] drivers: hv: remove IRQF_SAMPLE_RANDOM which is
 now a no-op
Thread-Topic: [PATCH 07/17] drivers: hv: remove IRQF_SAMPLE_RANDOM which is
 now a no-op
Thread-Index: AQHNZGTJ7qex08XYak+h+SBD/8MiyJcvBTiw
Date: Wed, 18 Jul 2012 13:14:25 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF923026AA1@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
 <1342560756-18737-8-git-send-email-tytso@mit.edu>
In-Reply-To: <1342560756-18737-8-git-send-email-tytso@mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: CH1PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%MIT.EDU$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Theodore Ts'o [mailto:tytso@mit.edu]
> Sent: Tuesday, July 17, 2012 5:32 PM
> To: Linux Kernel Developers List
> Cc: Theodore Ts'o; KY Srinivasan; Haiyang Zhang
> Subject: [PATCH 07/17] drivers: hv: remove IRQF_SAMPLE_RANDOM which is
> now a no-op
> 
> With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
> no-op; interrupt randomness is now collected unconditionally in a very
> low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
> flag was scheduled to be removed in 2009 on the
> feature-removal-schedule, so this patch is preparation for the final
> removal of this flag.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>

Acked-by: "K. Y. Srinivasan" <kys@microsoft.com>


Regards,

K. Y


