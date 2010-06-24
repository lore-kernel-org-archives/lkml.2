Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0FXJuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:50:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51160 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab0FXJuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:50:18 -0400
From: Andi Kleen <andi@firstfloor.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 14/52] fs: dcache scale subdirs
References: <20100624030212.676457061@suse.de>
	<20100624030727.818410048@suse.de>
Date: Thu, 24 Jun 2010 11:50:17 +0200
In-Reply-To: <20100624030727.818410048@suse.de> (npiggin@suse.de's message of
	"Thu, 24 Jun 2010 13:02:26 +1000")
Message-ID: <87pqzgaheu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de writes:

> Protect d_subdirs and d_child with d_lock, except in filesystems that aren't
> using dcache_lock for these anyway (eg. using i_mutex).

Different locking for different file systems seems a bit confusing.
Could the be unified?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
