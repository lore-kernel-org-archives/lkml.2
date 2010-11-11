Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0KKKNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:13:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54281 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab0KKKNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:13:32 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Stratford <tstratford@dragon-wing.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Accessibility Request
References: <AANLkTi=8EjNjS4=LF+LmDP-VhuiN7pgBQY+6c-zBgNXe@mail.gmail.com>
Date: Thu, 11 Nov 2010 11:13:25 +0100
In-Reply-To: <AANLkTi=8EjNjS4=LF+LmDP-VhuiN7pgBQY+6c-zBgNXe@mail.gmail.com>
	(Thomas Stratford's message of "Wed, 10 Nov 2010 14:17:18 -0500")
Message-ID: <87d3qcp3qy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Stratford <tstratford@dragon-wing.net> writes:

> My thought was that this could be implemented in the keyboard driver
> stack, and then do a simple substitution when a hot key is triggered.
> Is this possible? Is there already an implementation of something like
> this in the Linux world? Does this sound crazy? :)

See "man loadkeys"
The existing keymaps can already expand keys to multiple characters.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
