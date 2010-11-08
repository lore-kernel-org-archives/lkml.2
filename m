Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0KHLeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:34:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45722 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0KHLeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:34:10 -0500
From: Andi Kleen <andi@firstfloor.org>
To: 7eggert@gmx.de
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] Restrictions on module loading
References: <fMoIy-7gR-5@gated-at.bofh.it>
	<E1PFN7q-0000z3-Em@be1.7eggert.dyndns.org>
Date: Mon, 08 Nov 2010 12:34:07 +0100
In-Reply-To: <E1PFN7q-0000z3-Em@be1.7eggert.dyndns.org> (Bodo Eggert's message
	of "Mon, 08 Nov 2010 09:30:50 +0100")
Message-ID: <87zktkqcb4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@web.de> writes:
>
> - What about task switches or work queues?

That's indeed a problem. All request_module()s would need auditing
and if there's any triggered from a workqueue a new interface
that passes the credentials around.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
