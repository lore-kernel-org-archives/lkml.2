Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab2CEVso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:48:44 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:39084 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2CEVsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:48:43 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: Minchan Kim <minchan@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Mon, 5 Mar 2012 16:38:14 -0500
Subject: RE: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Topic: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Index: Acz51ClzWdL/EuMfQwCLniP/MCyyFwBQ9NSg
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB9456775@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
 <20120304065759.GA7824@barrios>
In-Reply-To: <20120304065759.GA7824@barrios>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1203050220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

Thank you for reviewing.

On 03/04/2012 01:57 AM, Minchan Kim wrote:
> On Fri, Mar 02, 2012 at 12:36:40PM -0500, Satoru Moriya wrote:
> 
> I agree this feature but current code is rather ugly on readbility.

I agree with you.

> Hillf's version looks to be much clean refactoring so after we merge 
> your patch, we can tidy it up with Hillf's patch.

Thanks. No problem.

Regards,
Satoru
