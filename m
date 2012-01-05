Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab2AEVCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:02:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34853 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab2AEVCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:02:23 -0500
From: Olof Johansson <olof@lixom.net>
To: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] x86: efi: cleanups and basic 32/64 bit support
Date: Thu,  5 Jan 2012 13:02:06 -0800
Message-Id: <1325797331-14758-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1325610682-24811-1-git-send-email-olof@lixom.net>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the second version of the refactored series of cleanups with the
32/64-bit enablement at the end (v4 for the patch in total).

I've revised patches based on review comments, change lists for each is
in the patches in question.

As Matthew pointed out: For mixed 32/64 operation on a traditional EFI
system, there are more pieces needed to deal with variables being passed
in, etc. It's not the case on Chrome OS due to a custom kernel boot
wrapper that sets up kernel boot args, etc. Still, this is a good step
on the way even for said traditional setups.

(I've labelled all patches as v4 even though some have only been posted
once and maybe not even changed to keep the series in sync)


-Olof

