Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2GREl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:41:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36825 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2GRElW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:41:22 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/17] uartlite: remove IRQF_SAMPLE_RANDOM which is now a no-op
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
	<1342560756-18737-9-git-send-email-tytso@mit.edu>
Date: Wed, 18 Jul 2012 06:41:14 +0200
In-Reply-To: <1342560756-18737-9-git-send-email-tytso@mit.edu> (Theodore
	Ts'o's message of "Tue, 17 Jul 2012 17:32:27 -0400")
Message-ID: <87txx5vfyt.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Theodore" == Theodore Ts'o <tytso@mit.edu> writes:

 Theodore> With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
 Theodore> no-op; interrupt randomness is now collected unconditionally in a very
 Theodore> low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
 Theodore> flag was scheduled to be removed in 2009 on the
 Theodore> feature-removal-schedule, so this patch is preparation for the final
 Theodore> removal of this flag.

 Theodore> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
 Theodore> Cc: Peter Korsgaard <jacmet@sunsite.dk>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
