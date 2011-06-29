Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1F2VLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:11:19 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:58828 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab1F2VLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:11:17 -0400
From: Richard Weinberger <richard@nod.at>
To: vitalivanov@gmail.com
Subject: Re: [PATCH] gcov: Disable CONSTRUCTORS for UML
Date: Wed, 29 Jun 2011 23:11:11 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Jeff Dike <jdike@addtoit.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1309381372.27360.4.camel@vitaliy-Vostro-1400>
In-Reply-To: <1309381372.27360.4.camel@vitaliy-Vostro-1400>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106292311.11714.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 29 Juni 2011, 23:02:52 schrieb Vitaliy Ivanov:
> From df71d030a87910e42045dea517bf955caa72d2a8 Mon Sep 17 00:00:00 2001
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Wed, 29 Jun 2011 23:25:32 +0300
> Subject: [PATCH] gcov: Disable CONSTRUCTORS for UML
> 
> Selecting GCOV for UML causing configuration mismatch:
> warning: (GCOV_KERNEL) selects CONSTRUCTORS which has unmet direct
> dependencies (!UML)
> 
> Constructors are not needed for UML.
> 
> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>

Acked-by: Richard Weinberger <richard@nod.at>
