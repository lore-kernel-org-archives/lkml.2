Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab2KGPEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:04:22 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51230 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab2KGPET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:04:19 -0500
Date: Wed, 7 Nov 2012 09:02:57 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Mathias Leblanc <mathias.leblanc@st.com>
Cc: Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Jean-Luc Blanc <jean-luc.blanc@st.com>
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
Message-ID: <20121107150257.GD14628@ennui.austin.ibm.com>
References: <1352290509-14834-1-git-send-email-mathias.leblanc@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352290509-14834-1-git-send-email-mathias.leblanc@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110715-7182-0000-0000-0000031E5995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 01:15:09PM +0100, Mathias Leblanc wrote:
>  * STMicroelectronics version 1.2.0, Copyright (C) 2010
>  * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
>  * This is free software, and you are welcome to redistribute it
>  * under certain conditions.
> 
> This is the driver for TPM chip from ST Microelectronics.
> 
> If you have a TPM security chip from STMicroelectronics working with
> an I2C, in menuconfig or .config choose the tpm driver on
> device --> tpm and activate the protocol of your choice before compiling
> the kernel.
> The driver will be accessible from within Linux.
> 
> Tested on linux x86/x64, beagleboard REV B & XM REV C and CHROMIUM OS
> 
> Signed-off-by: Mathias Leblanc <mathias.leblanc@st.com>

Hi Mathias,

  I didn't see a reply to my mail from Oct 31, and very little has
changed here.  Did I miss something?

Kent

