Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab1KRQr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:47:26 -0500
Received: from re04.intra2net.com ([82.165.46.26]:33024 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab1KRQrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:47:23 -0500
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Organization: Intra2net AG
To: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] Fix comparison using wrong pointer variable in dma debug code
Date: Fri, 18 Nov 2011 17:47:20 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.35.14-103.fc14.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
References: <4EC560F6.9050906@intra2net.com> <20111117200136.GC26847@hmsreliant.think-freely.org>
In-Reply-To: <20111117200136.GC26847@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111181747.20894.thomas.jarosch@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17. November 2011 21:01:36 Neil Horman wrote:
> Thanks for the catch!  Viro just pointed out you can also remove the ?
> true/false changes and extraneous parens, reducing it to:
> 
> (a->dev_addr == b->dev_addr) && (a->dev == b->dev)
> But its not strictly necessecary
> 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

I'd say just commit the fix, that rarely used function
is not worth the extra effort.

Cheers,
Thomas
