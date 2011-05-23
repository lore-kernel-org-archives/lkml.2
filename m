Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1EWQuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:50:22 -0400
Received: from 173-160-34-133-colorado.hfc.comcastbusiness.net ([173.160.34.133]:6945
	"EHLO ether.astekcorp.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756393Ab1EWQuV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:50:21 -0400
From: Dave Carroll <dcarroll@astekcorp.com>
To: Dave Carroll <dcarroll@astekcorp.com>, "'Milton Miller'" <miltonm@bga.com>
CC: LPPC <linuxppc-dev@lists.ozlabs.org>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Benjamin Herrenschmidt (E-mail)" <benh@kernel.crashing.org>
Date: Mon, 23 May 2011 10:50:07 -0600
Subject: RE: [ v4] powerpc: Force page alignment for initrd reserved memory
Thread-Topic: [ v4] powerpc: Force page alignment for initrd reserved memory
Thread-Index: AcwYxbbt15MAeWseSJm2zlfSwRRrGAAKbciAAB3/ipA=
Message-ID: <522F24EF533FC546962ECFA2054FF777373072AB78@MAILSERVER2.cos.astekcorp.com>
In-Reply-To: <522F24EF533FC546962ECFA2054FF777373072AB75@MAILSERVER2.cos.astekcorp.com>
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


I'm withdrawing this patch for the moment, due to two areas that need further research;

1) An adjacent FDT blob, as mentioned by Milton Miller, and

2) Potential interaction with the crash kernel, as used in
        init/initramfs.c

If anyone sees other interactions, please feel free to let me know ...

Thanks,
-Dave Carroll
