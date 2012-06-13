Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2FMX2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:28:23 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:58051 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2FMX2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:28:21 -0400
X-Greylist: delayed 822 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2012 19:28:21 EDT
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "rob@landley.net" <rob@landley.net>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 13 Jun 2012 19:28:03 -0400
Subject: RE: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite
 parameter to avoid missing messages in NVRAM
Thread-Topic: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite
 parameter to avoid missing messages in NVRAM
Thread-Index: Ac1Jaf3kQfy2nRzQSNG3UORn8S5p+AAc0YIAAA6J6JAAGwBGkAAyPwIgAGROu0A=
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB456@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB2B8@USINDEVS01.corp.hds.com>
 <CAGTjWtAb3XrsTtkvW=G0YN1RCVxYxcPksSh3jEogeEu4qWqv1Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F1930C820@ORSMSX103.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB451@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1930CA84@ORSMSX103.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1930CA84@ORSMSX103.amr.corp.intel.com>
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
 definitions=main-1206130266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think not - the limitation is EFI (ERST can handle several errors, I think that the ramoops patches are working with the assumption that
> enough storage is available too).
> 

I see.

> The question is how easy is it for EFI to determine the "type" of the saved error (which may be from the previous booted kernel - so
> no use using a global variable ... the information needs to be in persistent store).

OK. I will not use the global variable.
I can check the previous event from a header supplied by pstore ,such as "Panic#1 Part1".

Seiji
