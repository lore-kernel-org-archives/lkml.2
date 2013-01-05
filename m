Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3AEABu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 19:01:50 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:40081 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3AEABq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 19:01:46 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>
Subject: RE: [PATCH v3 0/2] pstore,efi_pstore: Avoid deadlock in
 non-blocking paths
Thread-Topic: [PATCH v3 0/2] pstore,efi_pstore: Avoid deadlock in
 non-blocking paths
Thread-Index: Ac3ewyNm+rP2IEnER5GHHHxmid334AATErOAADDDBKAACuFPgAK2aw+Q
Date: Sat, 5 Jan 2013 00:01:29 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3635F@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A03B@USINDEM103.corp.hds.com>
 <20121220190923.GP88797@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D414A2B22C@USINDEM103.corp.hds.com>
 <20121221233706.GA29709@lizard.sbx05280.losalca.wayport.net>
In-Reply-To: <20121221233706.GA29709@lizard.sbx05280.losalca.wayport.net>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-04_06:2013-01-04,2013-01-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1301040278
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0501qw6016882

Tony,

Can you review this patchset?

Seiji

> -----Original Message-----
> From: Anton Vorontsov [mailto:cbouatmailru@gmail.com]
> Sent: Friday, December 21, 2012 6:37 PM
> To: Seiji Aguchi
> Cc: Luck, Tony (tony.luck@intel.com); linux-kernel@vger.kernel.org; ccross@android.com; keescook@chromium.org; Satoru Moriya;
> dle-develop@lists.sourceforge.net; dzickus@redhat.com
> Subject: Re: [PATCH v3 0/2] pstore,efi_pstore: Avoid deadlock in non-blocking paths
> 
> On Fri, Dec 21, 2012 at 11:27:00PM +0000, Seiji Aguchi wrote:
> > Tony,
> >
> > Could you please apply this patchset to your tree?
> 
> Actually, I'd prefer to take both patches via pstore tree. The EFI part is isolated and small, so even if it conflicts, it would be easy to
> resolve, unlike to pstore core part.
> 
> So, would be great if Tony could give an Ack for EFI part and we'd merge this via pstore tree.
> 
> Thanks,
> Anton
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
