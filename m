Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0KZD0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 22:26:37 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50691 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab0KZD0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 22:26:36 -0500
From: Jay Vosburgh <fubar@us.ibm.com>
To: David Strand <dpstrand@gmail.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding: check for assigned mac before adopting the slaves mac address
In-reply-to: <AANLkTi=-DzUmopboX13V_cd=mZnmD=mBNNCuhQYF0PQQ@mail.gmail.com>
References: <AANLkTinpO=FmoecfV8epubXU4OrhFsXJ7-Kc68yNhMEs@mail.gmail.com> <31169.1290641617@death> <AANLkTi=-DzUmopboX13V_cd=mZnmD=mBNNCuhQYF0PQQ@mail.gmail.com>
Comments: In-reply-to David Strand <dpstrand@gmail.com>
   message dated "Wed, 24 Nov 2010 17:45:42 -0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Thu, 25 Nov 2010 19:26:31 -0800
Message-ID: <8879.1290741991@death>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Strand <dpstrand@gmail.com> wrote:

>We have a use case where we assign a mac to the bond device, because
>the slave device configuration may change periodically. With older
>kernels, it honored the assigned mac and everything was fine, with
>2.6.36 it now uses the mac of whatever slave device is first instead
>of our assigned one.
>
>ifenslave code and documentation appears to still support the old way,
>where a bond assigned mac will reign supreme, so this patch restores
>that behavior.

	Ok, fair enough.  If we want to get back to the original
behavior, however, your patch should only test for zero MAC address
instead of testing for zero MAC address in addition to first slave.

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
