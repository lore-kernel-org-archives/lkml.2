Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1BNQtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:49:45 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:33850 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756100Ab1BNQtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:49:42 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: n3RD5kkVM1lRb9cEb97bVkdsUigC4sjD_4tdcEGZMgXNOqU
 CKXgS66RJYkvTavZ6zb413GavoqvZwhKNv.2jGcJk0snZw5IhRPLTTEYv2IZ
 VIhdpEgCec8YsM2DEWzqodCWDlWA22moR0lEfNklYNioNixc8A_B7nCHke_p
 Bhxb0QQu7PwThGtBE7pLLKMVAeGVxZyFzsXIQ8SjfgUMveQpm21rDgRjVbWd
 2Cq61P7lvkFI34Aya0ksHN1flF2olLPRzMVpySAlitQeztXbyKgCFbeJRSAE
 5D7YlQeCiXMSng1er3IlKXocW3bMZ.rOL5NIPUXOkCWdnsWs-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 14 Feb 2011 10:49:39 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Kruse <pk@q-leap.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
In-Reply-To: <4D53FE43.8030106@q-leap.com>
Message-ID: <alpine.DEB.2.00.1102141046170.26158@router.home>
References: <4D53FE43.8030106@q-leap.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.DEB.2.00.1102141046172.26158@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011, Peter Kruse wrote:

> today one of our servers went berserk and produced literally 353
> page allocation failures in 7 minutes until it was reset
> (sysrq was still working).  I attach one of them as an example.
> The failures happened for different processes ranging from
> sshd, top, java, tclsh, ypserv, smbd, portmap, kswapd to Xvnc4.
> I already reported about an incidence with this server here:
> https://lkml.org/lkml/2011/1/19/145

Atomic allocations are failing there? gfpmask = 0x20?

> we have set vm.min_free_kbytes = 2097152 but the problem
> obviously did not go away.

2GB of reserves? How much memory does your system have?

> Please anybody, what is the cause of these failures?

Could you post the entire messages from the kernel log? We need the OOM
info to figure out more about the problem.

