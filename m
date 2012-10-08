Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2JHHJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 03:09:43 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:31988 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab2JHHJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 03:09:41 -0400
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <key@linux.vnet.ibm.com>, <jgunthorpe@obsidianresearch.com>
CC: <linux-kernel@vger.kernel.org>, <tpmdd-devel@lists.sourceforge.net>
Subject: RE: [tpmdd-devel] [PATCH] TPM: Issue TPM_STARTUP at driver load if
 the TPM has not been started
Thread-Topic: [tpmdd-devel] [PATCH] TPM: Issue TPM_STARTUP at driver load if
 the TPM has not been started
Thread-Index: AQHNn2pdOsnXAeayo0enYmQRsgYYcpekKczggABV0gCAAA83gIAACCAAgAS3loCABbi+wA==
Date: Mon, 8 Oct 2012 07:09:33 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440EC19C@MUCSE501.eu.infineon.com>
References: <20120930233012.GH30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121001161536.GC31620@obsidianresearch.com>
 <20121001171003.GA1117@ennui.austin.ibm.com>
 <20121001173908.GA22342@obsidianresearch.com>
 <20121004174114.GA6520@ennui.austin.ibm.com>
In-Reply-To: <20121004174114.GA6520@ennui.austin.ibm.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,
>  Peter, you mentioned you have some embedded setups, would you be able
> to test?

I could probably test it on the beagleboard c4 with our Infineon SLB9635 TT1.2 I2C TPM, 
but I'm currently not sure if I have the suspend/resume thing currently running correctly.

Apart from that I also have some 'ancient' x86 systems without TPM bios integration here 
(so the BIOS doesn't even know anything about a tpm), there I could test our LPC based tpms (SLB9635 / SLB9655).

Unfortunately it'll take some time, due to other priorities.
Please tell me when the patch is ready for testing.

Thanks,
Peter


