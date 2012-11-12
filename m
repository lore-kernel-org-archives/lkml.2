Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2KLJ2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 04:28:10 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:49159 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327Ab2KLJ2I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 04:28:08 -0500
From: Mathias LEBLANC <Mathias.LEBLANC@st.com>
To: Rusty Russell <rusty@ozlabs.org>, Kent Yoder <key@linux.vnet.ibm.com>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>
Date: Mon, 12 Nov 2012 10:26:31 +0100
Subject: RE: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C V1.2.0
Thread-Topic: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C V1.2.0
Thread-Index: Ac29q5BZDYlB29zuS72/4irBw0NDAADC29re
Message-ID: <35286B1AE75A7C47BFF0870081A31B4B38772D1927@SAFEX1MAIL4.st.com>
References: <1352315116-17612-1-git-send-email-mathias.leblanc@st.com>,<87mwys2spm.fsf@rustcorp.com.au>
In-Reply-To: <87mwys2spm.fsf@rustcorp.com.au>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable interrupts value must be 0 or 1. This restriction is defined by the fact of using the bool parameter (true or false)

Regards,

Mathias Leblanc
________________________________________
From: Rusty Russell [rusty@ozlabs.org]
Sent: 08 November 2012 13:18
To: Mathias LEBLANC; Kent Yoder; Rajiv Andrade; Marcel Selhorst; Sirrix AG; tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org; Jean-Luc BLANC; Mathias LEBLANC
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C V1.2.0

Mathias Leblanc <mathias.leblanc@st.com> writes:
> +static int interrupts ;
> +module_param(interrupts, bool, 0444);
> +MODULE_PARM_DESC(interrupts, "Enable interrupts");
> +
> +static int power_mgt = 1;
> +module_param(power_mgt, bool, 0444);
> +MODULE_PARM_DESC(power_mgt, "Power Management");

These are not bools, so why does module_param describe them as bool?

Cheers,
Rusty.