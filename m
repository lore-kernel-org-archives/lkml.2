Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab2DXWPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:15:12 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:54535 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab2DXWPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:15:10 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Richard Davies <richard@arachsys.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Minchan Kim <minchan.kim@gmail.com>
Date: Tue, 24 Apr 2012 18:14:37 -0400
Subject: RE: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Topic: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Index: Ac0h8xv9nGh1vV5/SCSe6m6Eo75RTgAdF23w
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C014649EC4D@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com>
 <20120424082019.GA18395@alpha.arachsys.com>
In-Reply-To: <20120424082019.GA18395@alpha.arachsys.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=11 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1204240258
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 04:20 AM, Richard Davies wrote:
> 
> I have run into problems with heavy swapping with swappiness==0 and 
> was pointed to this thread ( 
> http://marc.info/?l=linux-mm&m=133522782307215 )

Did you test this patch with your workload?
If yes, how did it come out?

> I strongly believe that Linux should have a way to turn off swapping 
> unless absolutely necessary. This means that users like us can run 
> with swap present for emergency use, rather than having to disable it 
> because of the side effects.

Agreed. That is why I proposed the patch.

> Personally, I feel that swappiness==0 should have this (intuitive) 
> meaning, and that people running RHEL5 are extremely unlikely to run 
> 3.5 kernels(!)
> 
> However, swappiness==-1 or some other hack is definitely better than 
> no patch.


Regards,
Satoru
