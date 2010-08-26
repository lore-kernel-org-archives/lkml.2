Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0HZJ4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:56:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:47535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab0HZJ4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:56:12 -0400
Message-ID: <4C7638E6.9050100@kernel.org>
Date: Thu, 26 Aug 2010 11:50:30 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Nick Piggin <npiggin@kernel.dk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
References: <20100825132815.108d8217@bike.lwn.net> <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com> <4C762BF9.5010305@kernel.org> <20100826094613.GA6411@amd> <4C7638B7.9060306@kernel.org>
In-Reply-To: <4C7638B7.9060306@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 09:56:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 11:49 AM, Tejun Heo wrote:
> Probably similar rationale of not doing stop_machine() on module
> unload, I suppose.  Onlining something is usually considered hotter

s/unload/load/ :-)

-- 
tejun
