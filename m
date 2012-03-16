Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032006Ab2CPNis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:38:48 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:44637 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031736Ab2CPNiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:38:25 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Adrian Hunter <adrian.hunter@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Chen Gong (gong.chen@linux.intel.com)" <gong.chen@linux.intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 16 Mar 2012 09:38:00 -0400
Subject: RE: [Patch]Fix reason_str of pstore so that it can work correctly
Thread-Topic: [Patch]Fix reason_str of pstore so that it can work correctly
Thread-Index: Ac0DTUrKWCPdlADCTCaufCWnLoxa7AALJj3A
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E32064B51@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2DACC35686@USINDEVS01.corp.hds.com>
 <4F62F73A.6020108@intel.com>
In-Reply-To: <4F62F73A.6020108@intel.com>
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
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1203160098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for reviewing my patch.
I will update it in accordance with your comment.

Seiji

> It would be better to make it so it would not break e.g.
> 
> static const char *get_reason_str(enum kmsg_dump_reason reason) {
> 	switch (reason) {
> 	KMSG_DUMP_PANIC:
> 		return "Panic";
> 	KMSG_DUMP_OOPS:
> 		return "Oops";
> 	KMSG_DUMP_EMERG:
> 		return "Emergency";
> 	KMSG_DUMP_RESTART:
> 		return "Restart";
> 	KMSG_DUMP_HALT:
> 		return "Halt";
> 	KMSG_DUMP_POWEROFF:
> 		return "Poweroff";
> 	default:
> 		return "Unknown";
> 	}
> }
