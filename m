Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1KNIzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 03:55:09 -0500
Received: from senmx12-mx.siemens-enterprise.com ([62.134.46.10]:37831 "EHLO
	senmx12-mx.siemens-enterprise.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab1KNIzH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 03:55:07 -0500
From: "Kokoris, Ioannis" <ioannis.kokoris@siemens-enterprise.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 14 Nov 2011 09:55:04 +0100
Subject: RE: [PATCH] P1021: set IReady in QE Microcode Upload
Thread-Topic: [PATCH] P1021: set IReady in QE Microcode Upload
Thread-Index: AQHMoJB2KAiKIl6KR0iOAe8H9Sg5BpWsEXMg
Message-ID: <026483A88B848047A08C3F03E20822D0267B1F4BDB@MCHP058A.global-ad.net>
References: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net>
 <4EBD4FB8.2020406@freescale.com>
In-Reply-To: <4EBD4FB8.2020406@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Kokoris, Ioannis wrote:
>> Hi,
>>
>> QE Microcode Initialization using qe_upload_microcode() does not work
>> on P1021 if the IRAM-Ready register is not set after the microcode
>> upload. This patch adds a definition for the "I-RAM Ready" register and
>> sets it uppon microcode upload completion.
>
>Will this code still work on other QE parts, like the MPC8323?
>

Ready register is needed for ROM-less devices such as P1021, MPC859, MPC8306 etc. 
For ROM-based devices such as MCP8323 the Ready register does not exist.
Is there a global definition for conditionally including this code?

Regards,
Ioannis
