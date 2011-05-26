Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab1EZS6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:58:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58480 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab1EZS6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:58:39 -0400
Date: Thu, 26 May 2011 20:58:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: Re: [RFC Patch 5/6] slimdump: Capture slimdump for fatal MCE generated crashes
Message-ID: <20110526185838.GG4065@one.firstfloor.org>
References: <20110526170722.GB23266@in.ibm.com> <20110526172305.GA18295@in.ibm.com> <20110526174447.GC29496@redhat.com> <20110526180931.GF4065@one.firstfloor.org> <20110526182618.GD29496@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526182618.GD29496@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we are just extracting and saving MCE registers from vmcore, then
> reboot time does not increase. It increases only if user decides to
> extract and save extra data from vmcore.

Hmm I was thinking of user space usually saving the dump first
before analyzing it. But yes it could probably do some minimal
analysis first.

I guess most user spaces just won't change and will just continue
to DTWT though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
