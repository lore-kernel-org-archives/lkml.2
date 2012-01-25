Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2AYP1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:27:51 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:52938
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541Ab2AYP1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:27:50 -0500
X-SpamScore: -5
X-BigFish: PS-5(zzbb2dI9371I98dKzz1202hzz8275dhz2fhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:207.46.4.139;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0602HT005.namprd06.prod.outlook.com;RD:none;EFVD:NLI
Message-ID: <4F201F6E.9020201@ixiacom.com>
Date: Wed, 25 Jan 2012 07:27:42 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>
Subject: Re: [PATCH] Support single byte reads from integers published in
 procfs by kernel/sysctl.c
References: <4F1C5995.3060806@ixiacom.com> <m1fwf6pjal.fsf@fess.ebiederm.org> <4F1D8180.9030509@ixiacom.com> <m1mx9enzr0.fsf@fess.ebiederm.org> <4F1D8F37.6020806@ixiacom.com> <20120124145037.f8223e37.akpm@linux-foundation.org>
In-Reply-To: <20120124145037.f8223e37.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.23.154.50]
X-MS-Exchange-CrossPremises-AuthSource: SN2PRD0602HT005.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Rules-Execution-History: Support - Juniper
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN2PRD0602HT005.namprd06.prod.outlook.com
X-OriginatorOrg: ixiacom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/2012 2:50 PM, Andrew Morton wrote:
> We fixed an instance of this in procfs a while ago (maybe a year ago?).
> But I forget where it was.  It is surprising that a bug of this nature
> survived so long.

Also related to procfs, I posted the following fix for pread() and seq_file but
haven't received any feedback.

	https://lkml.org/lkml/2012/1/22/61

Would you take a look ?

Earl

