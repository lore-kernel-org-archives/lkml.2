Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab1GSAow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 20:44:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:32326 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1GSAov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 20:44:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,225,1309762800"; 
   d="scan'208";a="29165635"
From: Andi Kleen <andi@firstfloor.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/34] System Firmware Interface
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
	<1310994528-26276-2-git-send-email-prarit@redhat.com>
Date: Mon, 18 Jul 2011 17:43:08 -0700
In-Reply-To: <1310994528-26276-2-git-send-email-prarit@redhat.com> (Prarit
	Bhargava's message of "Mon, 18 Jul 2011 09:08:15 -0400")
Message-ID: <m2vcuz3xsz.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava <prarit@redhat.com> writes:

Wow that's a cc list from hell. Cut down to linux-kernel.

> This patch introduces a general System Firmware interface to the kernel, called
> sysfw.

Could you expand somewhat WHY you want this. What is wrong with the
current code?

As for user space access on x86 "dmidecode"/libdmi works for nearly everyone,
doesn't it?


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
