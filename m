Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2BHW5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:57:12 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:60917 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab2BHW5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:57:11 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>, "Luck, Tony" <tony.luck@intel.com>
CC: Chen Gong <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "'ak@linux.intel.com'" <ak@linux.intel.com>,
        "'hughd@chromium.org'" <hughd@chromium.org>,
        "'mingo@elte.hu'" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 8 Feb 2012 17:56:39 -0500
Subject: RE: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Thread-Topic: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC)
 below smp_send_stop()
Thread-Index: Aczms9eYn9XfEmyNRGqK6tG339o47gAAOEeg
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2DAC650D6E@USINDEVS01.corp.hds.com>
References: <20120111172544.GS5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28FD61F@ORSMSX104.amr.corp.intel.com>
 <32727E9A83EE9A42A1F0906295A3A77B2C78F49973@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2DA7B65F2A@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F0275EE@ORSMSX104.amr.corp.intel.com>
 <20120203171809.GL5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F02B380@ORSMSX104.amr.corp.intel.com>
 <20120203225740.GO5650@redhat.com> <20120208201940.GZ5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F038F46@ORSMSX104.amr.corp.intel.com>
 <20120208224837.GB5650@redhat.com>
In-Reply-To: <20120208224837.GB5650@redhat.com>
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
 definitions=main-1202080255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

You are the appropriate person to apply this patch.

Seiji

-----Original Message-----
From: Don Zickus [mailto:dzickus@redhat.com] 
Sent: Wednesday, February 08, 2012 5:49 PM
To: Luck, Tony
Cc: Seiji Aguchi; Chen Gong; linux-kernel@vger.kernel.org; Matthew Garrett; Vivek Goyal; Chen, Gong; akpm@linux-foundation.org; Brown, Len; Huang, Ying; 'ak@linux.intel.com'; 'hughd@chromium.org'; 'mingo@elte.hu'; jmorris@namei.org; a.p.zijlstra@chello.nl; namhyung@gmail.com; dle-develop@lists.sourceforge.net; Satoru Moriya
Subject: Re: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop()

On Wed, Feb 08, 2012 at 09:28:37PM +0000, Luck, Tony wrote:
> > If I put together a patch to address this would you be willing to 
> > let Seiji move the kmsg_dump to below smp_send_stop()?
> 
> I'd "Ack" it ... not my decision whether to apply it.

Sure, I understand. But I figured your objection is holding it up to. ;-)

Let me put together a patch for that change.

Cheers,
Don
