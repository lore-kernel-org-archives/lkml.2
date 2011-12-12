Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1LLWda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:33:30 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:56094 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1LLWd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:33:28 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Lukas Czerner <lczerner@redhat.com>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jiayingz@google.com" <jiayingz@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 12 Dec 2011 17:32:57 -0500
Subject: RE: [PATCH]tracepoint: add drop_transaction/update_superblock_end
 to jbd2
Thread-Topic: [PATCH]tracepoint: add drop_transaction/update_superblock_end
 to jbd2
Thread-Index: AcyvU0XPZJhiiHsvTb6Tp5XxhYabWAJynv8A
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47D9@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57C90585@USINDEVS01.corp.hds.com>
 <alpine.LFD.2.00.1111301227200.4662@dhcp-27-109.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1111301227200.4662@dhcp-27-109.brq.redhat.com>
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
 definitions=main-1112120243
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch adds trace_jbd2_drop_transaction and trace_jbd2_update_superblock_end
>> because there are similar tracepoints in jbd and they are needed in jbd2 as well.
>>
>> Seiji
>
>Looks good, thanks.
>
>Reviewed-by: Lukas Czerner <lczerner@redhat.com>
>
>>
>>
>>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

Are there anyone else who can review my patch?

Seiji
