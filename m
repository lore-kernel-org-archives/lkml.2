Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab1GSTSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:18:54 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:56650 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1GSTSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:18:53 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 19 Jul 2011 15:18:15 -0400
Subject: RE: [RFC][PATCH -mmotm 0/4] Improvement of pstore/kmsg_dump in
 kexec/panic path
Thread-Topic: [RFC][PATCH -mmotm 0/4] Improvement of pstore/kmsg_dump in
 kexec/panic path
Thread-Index: AcxGRGRcQx7/QfEmSqyp64QpXnGABQAA7sHA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64EC@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64C2@USINDEVS01.corp.hds.com>
 <20110719184759.GC7001@redhat.com>
In-Reply-To: <20110719184759.GC7001@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6JJJ2lC008900

Hi,

>Why can't we log something in user
>space when user initiates a reboot, let it get logged in /var/log/messages
>and then umount the file root and go ahead with reboot. Why does kernel
>need to capture that info in NVRAM.

Thank you for coordinating discussion.
I will reply to your question.

Regards,

Seiji

>-----Original Message-----
>From: Vivek Goyal [mailto:vgoyal@redhat.com]
>Sent: Tuesday, July 19, 2011 2:48 PM
>To: Seiji Aguchi
>Cc: kexec@lists.infradead.org; linux-kernel@vger.kernel.org; linux-mtd@lists.infradead.org; Eric W. Biederman; KOSAKI
>Motohiro; Americo Wang; Matthew Garrett; tony.luck@intel.com; Andrew Morton; Jarod Wilson; hpa@zytor.com;
>dzickus@redhat.com; dle-develop@lists.sourceforge.net; Satoru Moriya
>Subject: Re: [RFC][PATCH -mmotm 0/4] Improvement of pstore/kmsg_dump in kexec/panic path
>
>On Tue, Jul 19, 2011 at 02:23:26PM -0400, Seiji Aguchi wrote:
>> Hi,
>>
>> [Upstream status]
>>    Discussion about kmsg_dump() in kdump path:
>>     - Eric and Vivek are worried about reliability of existing kmsg_dump().
>>     - Especially, Vivek would like to remove a RCU  function call chain in kdump path
>> ã€€ã€€ã€€ which kernel modules can register their function calls freely.
>>
>>    Discussion about pstore in nmi_hander.
>>     - Don Zickus found an issue of pstore in nmi_handler due to its mutex_lock.
>
>You did not answer my questions in the last posting mail thread and gone
>ahead with the new posting. How are we supposed to discuss something. This
>has been a problem on this mail thread since the beginneing. There is
>little open discussion.
>
>So if you want to make any progress in this direction, what will help
>is open discussion.
>
>Locking is going to be a problem. So atleast we can remove kmsg_dump()
>infrastructure from reboot path. Why can't we log something in user
>space when user initiates a reboot, let it get logged in /var/log/messages
>and then umount the file root and go ahead with reboot. Why does kernel
>need to capture that info in NVRAM.
>
>If we can get rid of all the logging thing on reboot path, then at least
>it does not need to be lock protected with crash path.
>
>Thanks
>Vivek
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
