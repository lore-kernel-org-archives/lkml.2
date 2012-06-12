Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2FLS5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:57:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39307 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2FLS5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:57:34 -0400
MIME-Version: 1.0
In-Reply-To: <953B7F5DA8C0F44CBD2621D8763F4F6005F79F@SHSMSX101.ccr.corp.intel.com>
References: <953B7F5DA8C0F44CBD2621D8763F4F6005F79F@SHSMSX101.ccr.corp.intel.com>
Date: Tue, 12 Jun 2012 13:57:32 -0500
Message-ID: <CAM0nabHV6CepQyXeVZiv2XT9WHPgMy=prdK-8fNgyrCZ4v6dSg@mail.gmail.com>
Subject: Re: [PATCH 1/2] driver: add PPI support in tpm driver
From: Kent Yoder <shpedoikal@gmail.com>
To: "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>,
        "srajiv@linux.vnet.ibm.com" <srajiv@linux.vnet.ibm.com>,
        "m.selhorst@sirrix.com" <m.selhorst@sirrix.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "Cihula, Joseph" <joseph.cihula@intel.com>,
        "Wei, Gang" <gang.wei@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xiaoyan,

On Tue, May 22, 2012 at 10:34 PM, Zhang, Xiaoyan
<xiaoyan.zhang@intel.com> wrote:
> From: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
>
> The Physical Presence Interface enables the OS and the BIOS to cooperate
> and provides a simple and straightforward platform user experience for
> administering the TPM without sacrificing security.
>
> Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
> ---
>  drivers/char/tpm/tpm.c |  462 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm.h |   18 ++
>  2 files changed, 480 insertions(+), 0 deletions(-)

  This code looks clean - my only suggestion would be to add an #ifdef
CONFIG_ACPI around it so it compiles out on ppc.

Kent

-- 
IBM LTC Security
