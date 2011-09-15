Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935325Ab1IOXK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:10:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56148 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935246Ab1IOXK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:10:57 -0400
Date: Fri, 16 Sep 2011 01:10:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH 07/27] Initconst section fixes for POWERPC
Message-ID: <20110915231053.GD7761@one.firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org> <1316117394-21666-8-git-send-email-andi@firstfloor.org> <CA+5PVA66idjR6uLaJOJm81ZJrjRiYQVJMvKNttAS7B=4iUoqVQ@mail.gmail.com> <4E726489.6080606@linux.intel.com> <CA+5PVA52Q+9jBbF7fdjDgpkv9rAwPKgyH+34zMPxYXusn-LctQ@mail.gmail.com> <20110915205709.GB7761@one.firstfloor.org> <CA+5PVA416wv7fLxyKCe3w+LAmqhJa3d14TeqXxwM_oAbixci5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA416wv7fLxyKCe3w+LAmqhJa3d14TeqXxwM_oAbixci5w@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not arguing against the patch.  I just want to poke around with
> what you're reporting.  Where can one get the toolkit?

You currently need a gcc 4.7, HJ Lu's binutils, a rather largish patchkit
of mine to enable a kernel LTO build and then it doesn't quite build yet
due to some gcc bugs, but gets far enough to complain about invalid
section attribute mismatches.

I think the people who originally introduced initconst* triggered
it in the linker, but I'm not fully sure how they did it.
What happens is that the linker silently has to change the 'r'
attribute of that section, this can be flagged.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
