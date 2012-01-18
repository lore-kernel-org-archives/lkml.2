Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2ARWkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:40:53 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:36477 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2ARWkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:40:52 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Tony Luck <tony.luck@intel.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Jan 2012 17:40:30 -0500
Subject: RE: [PATCH v5] ramoops: use pstore interface
Thread-Topic: [PATCH v5] ramoops: use pstore interface
Thread-Index: AczWLsuZ7aQTQ+bNQMW+ML2cJY3APgAAocAA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>
References: <20120117235852.GA4877@www.outflux.net>
	<20120118140603.0fc22302.akpm@linux-foundation.org>
 <CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
In-Reply-To: <CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1201180241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>  static int __exit ramoops_remove(struct platform_device *pdev)
>>>  {
>>> +#if 0
>>> +     /* TODO(kees): We cannot unload ramoops since pstore doesn't support
>>> +      * unregistering yet.
>>> +      */
>>
>> Well that sucks.  Is pstore getting fixed?
>
>Tony, any plans for changing this? I'm ready when it does! :)
>
>

I have an question about this.

Are there any specific usecases you need to unload ramoops?

If users really would like to get kernel messages, unregistering ramoops is not needed.

Seiji
