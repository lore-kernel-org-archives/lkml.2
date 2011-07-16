Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1GPTRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 15:17:39 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:60500 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754286Ab1GPTRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 15:17:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IrxPVRyLHFqRLUWBsJrqXjOEEQTaBKLwmQx1YfaM/wLHJFvPtVhHmlSp+jlnT/5Yp3edlA8IXhW4/qSbzGaClCii5+iKaTejkXa/d7Rt++88nkOWi6/Y/GBCUal/uobQ;
Date: Sat, 16 Jul 2011 12:17:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, tpmdd-devel@lists.sourceforge.net
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: linux-next: Tree for July 16 (tpm)
Message-Id: <20110716121734.97b2e291.rdunlap@xenotime.net>
In-Reply-To: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
References: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jul 2011 00:08:15 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110707:

When CONFIG_PNP is not enabled:

drivers/char/tpm/tpm_tis.c:845: error: implicit declaration of function 'tpm_tis_reenable_interrupts'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
