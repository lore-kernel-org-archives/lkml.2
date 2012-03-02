Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab2CBV5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:57:13 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:46055 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab2CBV5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:57:12 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mjg@redhat.com" <mjg@redhat.com>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>
Date: Fri, 2 Mar 2012 16:55:56 -0500
Subject: RE: [PATCH 1/2] x86, reboot: revert stop_other_cpus to using IRQ
 with NMI fallback
Thread-Topic: [PATCH 1/2] x86, reboot: revert stop_other_cpus to using IRQ
 with NMI fallback
Thread-Index: Acz4uR7a6dfHO5KsS9KW3BbyDKPlSQABfMjQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2DACAECAE4@USINDEVS01.corp.hds.com>
References: <1329164860-668-1-git-send-email-dzickus@redhat.com>
 <1329164860-668-2-git-send-email-dzickus@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2DACAECA8F@USINDEVS01.corp.hds.com>
 <20120302211156.GM3083@redhat.com>
In-Reply-To: <20120302211156.GM3083@redhat.com>
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
 definitions=main-1203020202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I don't think kdump uses the notifier_chain.

Sorry about that. I looked at old kernel.
Currently, kdump uses register_nmi_handler() as well.

Seiji


