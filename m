Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2KHMVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:21:20 -0500
Received: from ozlabs.org ([203.10.76.45]:48693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab2KHMVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:21:16 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Mathias Leblanc <mathias.leblanc@st.com>,
        Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jean-Luc Blanc <jean-luc.blanc@st.com>,
        Mathias Leblanc <mathias.leblanc@st.com>
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C V1.2.0
In-Reply-To: <1352315116-17612-1-git-send-email-mathias.leblanc@st.com>
References: <1352315116-17612-1-git-send-email-mathias.leblanc@st.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 08 Nov 2012 22:48:45 +1030
Message-ID: <87mwys2spm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
