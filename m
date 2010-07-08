Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0GHPkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:40:15 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:58353 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab0GHPkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:40:13 -0400
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
Date: Thu, 8 Jul 2010 17:40:32 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc4; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       zheng.yan@oracle.com
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <20100708143109.GR15984@think>
In-Reply-To: <20100708143109.GR15984@think>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081740.34000.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 08 Juli 2010, 16:31:09 schrieb Chris Mason:
> Neither Yan nor I have been able to reproduce this locally, but a few
> people have now hit it.  Johannes, are you available to try out a
> debugging kernel to try and track this down?

Sure, just tell me what to do. Is it enough to recompile the kernel with debug 
options enabled or are special debug patches necessary?

regards,
  Johannes
