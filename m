Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab0KVV1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:27:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:61390 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab0KVV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:27:21 -0500
Date: Mon, 22 Nov 2010 13:26:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 22 (kvm)
Message-Id: <20101122132627.bd4e88ef.randy.dunlap@oracle.com>
In-Reply-To: <20101122134911.b7e106f9.sfr@canb.auug.org.au>
References: <20101122134911.b7e106f9.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 13:49:11 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101119:


kvm.c:(.init.text+0x11f49): undefined reference to `kvm_register_clock'

when CONFIG_KVM_CLOCK is not enabled.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
