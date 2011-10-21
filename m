Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1JUXuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 19:50:22 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:42087 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1JUXuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 19:50:21 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Fri, 21 Oct 2011 19:48:48 -0400
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: AcyJGVznsX9NDC5uS3SAH8qxSUPXxwHMp11C
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB4F747B1@USINDEVS02.corp.hds.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
 <20110901100650.6d884589.rdunlap@xenotime.net>
 <20110901152650.7a63cb8b@annuminas.surriel.com>
 <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
 <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com>
 <20111011125419.2702b5dc.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com>
 <20111011135445.f580749b.akpm@linux-foundation.org>
 <4E95917D.3080507@redhat.com>
 <20111012122018.690bdf28.akpm@linux-foundation.org>,<4E95F167.5050709@redhat.com>
In-Reply-To: <4E95F167.5050709@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1110210298
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 03:58 PM, Rik van Riel wrote:
> On 10/12/2011 03:20 PM, Andrew Morton wrote:
>> On Wed, 12 Oct 2011 09:09:17 -0400
>> Rik van Riel<riel@redhat.com>  wrote:
>>
>> Do we actually have a real-world application which is hurting from
>> this?
> 
> Satoru-san?

Sorry for late reply.

We do.
Basically we need this kind of feature for almost all our latency
sensitive applications to avoid latency issue in memory allocation.

Currently we run those applications on custom kernels which this
kind of patch is applied to. But it is hard for us to support every
kernel version for it. Also there are several customers who can't
accept a custom kernel and so they must use other commercial Unix.
If this feature is accepted, they will definitely use it on their
systems.

Thanks,
Satoru