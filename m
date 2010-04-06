Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0DFK0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 06:26:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52781 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab0DFK0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:26:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Arch specific mmap attributes (Was: mprotect pgprot handling weirdness)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
In-Reply-To: <1270539044.13812.65.camel@pasglop>
References: <20100406151751.7E4E.A69D9226@jp.fujitsu.com> <1270539044.13812.65.camel@pasglop>
Message-Id: <20100406185246.7E63.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Apr 2010 19:26:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, I see. No biggie. The main deal remains how we want to do that
> inside the kernel :-) I think the less horrible options here are
> to either extend vm_flags to always be 64-bit, or add a separate
> vm_map_attributes flag, and add the necessary bits and pieces to
> prevent merge accross different attribute vma's.

vma->vm_flags already have VM_SAO. Why do we need more flags?
At least, I dislike to add separate flags member into vma.
It might introduce unnecessary messy into vma merge thing.



> The more I try to hack it into vm_page_prot, the more I hate that
> option.


