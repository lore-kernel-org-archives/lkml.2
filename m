Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab2KPBQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:16:34 -0500
Received: from ozlabs.org ([203.10.76.45]:38022 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2KPBQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:16:32 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        "tpmdd-devel\@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>
Subject: RE: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C V1.2.0
In-Reply-To: <35286B1AE75A7C47BFF0870081A31B4B38772D1927@SAFEX1MAIL4.st.com>
References: <1352315116-17612-1-git-send-email-mathias.leblanc@st.com> <87mwys2spm.fsf@rustcorp.com.au> <35286B1AE75A7C47BFF0870081A31B4B38772D1927@SAFEX1MAIL4.st.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 16 Nov 2012 11:28:49 +1030
Message-ID: <87fw4aics6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathias LEBLANC <Mathias.LEBLANC@st.com> writes:

> Variable interrupts value must be 0 or 1. This restriction is defined by the fact of using the bool parameter (true or false)

But you can't pass an int to module_param(..., bool,...).

Cheers,
Rusty.
