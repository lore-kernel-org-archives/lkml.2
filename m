Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2BCRmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:42:06 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:60024 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab2BCRmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:42:03 -0500
Date: Fri, 3 Feb 2012 15:39:31 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] TPM: Zero buffer whole after copying to userspace
Message-ID: <20120203173931.GC21715@hardened-box.ibm.com>
References: <1323196162-2717-1-git-send-email-tim.gardner@canonical.com>
 <1323196162-2717-2-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323196162-2717-2-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12020317-1524-0000-0000-000001561BC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Dec 2011, Tim Gardner wrote:

> Commit 3321c07ae5068568cd61ac9f4ba749006a7185c9 correctly clears the TPM
> buffer if the user specified read length is >= the TPM buffer length. However,
> if the user specified read length is < the TPM buffer length, then part of the
> TPM buffer is left uncleared.
> 
> Reported-by: Seth Forshee <seth.forshee@canonical.com>
> Cc: Debora Velarde <debora@linux.vnet.ibm.com>
> Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> Cc: Marcel Selhorst <m.selhorst@sirrix.com>
> Cc: tpmdd-devel@lists.sourceforge.net
> Cc: stable@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Applied to github.com:srajiv/tpm.git next

Thanks,
Rajiv

