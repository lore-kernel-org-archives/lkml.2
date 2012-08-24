Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239Ab2HXVdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:33:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172Ab2HXVdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:33:36 -0400
Message-ID: <5037F317.7020606@zytor.com>
Date: Fri, 24 Aug 2012 14:33:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@kernel.org, torvalds@linux-foundation.org, andreas.herrmann3@amd.com,
        bp@amd64.org, robert.richter@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] x86, fpu: cleanups, introduce non-lazy FPU restore
 for xsave
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
In-Reply-To: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have applied this to tip:x86/fpu, but I have also asked Suresh to
prepare a followon patch to decouple eager save from the existence of
the XSAVE instruction.  It seems pretty clear that eager save is a net
benefit in the presence of the XSAVEOPT, but it isn't as clear for only
having XSAVE, as far as I can tell.  Either way it would seem to be a
policy decision that is somewhat separate from the exact instruction.

	-hpa
