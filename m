Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2KLIsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 03:48:13 -0500
Received: from smtp2.infineon.com ([217.10.60.23]:52210 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2KLIsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 03:48:00 -0500
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <key@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>
CC: <tpmdd-devel@lists.sourceforge.net>,
        <linux-security-module@vger.kernel.org>
Subject: RE: [tpmdd-devel] [PATCH] tpm: add documentation for sysfs
 interfaces
Thread-Topic: [tpmdd-devel] [PATCH] tpm: add documentation for sysfs
 interfaces
Thread-Index: AQHNvdXCMTFMLtSZ0U2RcQhDHKg9R5fl6MHQ
Date: Mon, 12 Nov 2012 08:47:55 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440F6973@MUCSE501.eu.infineon.com>
References: <20121108171006.GA30286@ennui.austin.ibm.com>
In-Reply-To: <20121108171006.GA30286@ennui.austin.ibm.com>
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

Hi Kent,

thanks a lot for this effort!
I really appreciate it.

> +What:		/sys/class/misc/tpmX/device/active
> +Date:		April 2006
> +KernelVersion:	2.6.17
> +Contact:	tpmdd-devel@lists.sf.net
> +Description:	The "active" property prints a '1' if the TPM chip is accepting
> +		commands. An inactive TPM chip still contains all the state of
> +		an active chip (Storage Root Key, NVRAM, etc), and can be
> +		visible to the OS, but will not accept commands.

Hmm, I know this is a tricky one (enabled/activated).
maybe this would be better as:
-		visible to the OS, but will not accept commands.
+		visible to the OS, but will only accept a restricted set of commands.
+		See TCG specification(...) for more information.



> +What:		/sys/class/misc/tpmX/device/cancel
> +Date:		June 2005
> +KernelVersion:	2.6.13
> +Contact:	tpmdd-devel@lists.sf.net
> +Description:	The "cancel" property allows you to cancel the currently
> +		pending TPM command. Echoing any value to cancel will call the
> +		TPM vendor specific cancel operation.

I'd go for writing instead of echoing but this might only be bike-shedding.
-		pending TPM command. Echoing any value to cancel will call the
+		pending TPM command. Writing any value to cancel will call the


The rest is great.
Reviewed-by: Peter Huewe <peter.huewe@infineon.com>
Signed-off-by: Peter Huewe <peter.huewe@infineon.com> 
	

Thanks,
Peter
