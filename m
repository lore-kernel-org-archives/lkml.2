Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2KURhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:37:50 -0500
Received: from smtp2.infineon.com ([217.10.60.23]:35331 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2KURhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:37:48 -0500
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <jgunthorpe@obsidianresearch.com>
CC: <key@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <tpmdd-devel@lists.sourceforge.net>
Subject: RE: [PATCH resend] TPM: Issue TPM_STARTUP at driver load if the TPM
 has not been started
Thread-Topic: [PATCH resend] TPM: Issue TPM_STARTUP at driver load if the
 TPM has not been started
Thread-Index: AQHNx7dElapQS2HSZE2eryDfqZhcBpfz8S/AgACKJICAABJ28A==
Date: Wed, 21 Nov 2012 17:37:44 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440F7776@MUCSE501.eu.infineon.com>
References: <20120930233012.GH30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121001161536.GC31620@obsidianresearch.com>
 <20121001171003.GA1117@ennui.austin.ibm.com>
 <20121001173908.GA22342@obsidianresearch.com>
 <20121004174114.GA6520@ennui.austin.ibm.com>
 <74A44E99E3274B4CB570415926B37D440EC19C@MUCSE501.eu.infineon.com>
 <20121121071015.GD19837@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440F7675@MUCSE501.eu.infineon.com>
 <20121121172929.GA6406@obsidianresearch.com>
In-Reply-To: <20121121172929.GA6406@obsidianresearch.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.249]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

>Great, I'll send an updated version, thanks!
;) You're welcome.

>> >+struct tpm_startup_in {
>> >+	__be16	startup_type;
>> >+} __packed;
>> 
>> 
>> All the other user
>> __attribute__((packed));
>> Care to change to be consistent?

> I used to __packed to avoid a checkpatch warning, they should probably
> all be changed?

Oh you're right - then sorry about my complaint.
Then I'd prefer submitting it as __packed and write another patch which change the remaining ones.
Are you creating the patch to change or should I?

Peter

