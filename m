Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1KXHrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:47:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:50088 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab1KXHrA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:47:00 -0500
Subject: Re: Fix for fsl_upm
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <4EA9683D.8030100@dev.rtsoft.ru>
Date: Thu, 24 Nov 2011 01:46:32 -0600
Cc: benh@kernel.crashing.org, paulus@samba.org, Shengzhou.Liu@freescale.com,
        Shaohui.Xie@freescale.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <0DAA4F0B-0C32-4CF8-9E3A-EFB8B898026E@kernel.crashing.org>
References: <4EA9683D.8030100@dev.rtsoft.ru>
To: Rusev <arusev@dev.rtsoft.ru>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 27, 2011, at 9:18 AM, Rusev wrote:

> patch is vs. 2.6.39, yet it applied to 3.1
> 
> 
> 
> Fix of UPM driver for Freescale PowerPC processors
> 
> If Freescale LBC driver fails to initialise itself from device tree,
> then internal structure is freed only but not NULL-fied.
> As result functions fsl_lbc_find() after checking the structure is not NULL are
> trying to access device registers.
> 
> Signed-off-by: Alexandre Rusev <arusev@dev.rtsoft.ru> 

applied to next

- k