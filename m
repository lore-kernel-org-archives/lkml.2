Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2BBKYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:24:50 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64888 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab2BBKYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:24:49 -0500
Message-ID: <4F2A646D.4010907@gmail.com>
Date: Thu, 02 Feb 2012 11:24:45 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: ranjitm@google.com
Subject: Linsched - any news about it?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I would like to play around a bit with Linsched. The last
announce that I'm aware of is the one dated 2010-10-12 (1
year ago):
[ANNOUNCE] Linsched for 2.6.35 released by Ranjit Manomohan.

Is there any further update?

Second thing is that the git repo of that announce seems not
working.
I've found this one by Paul Turner on the web:
https://github.com/paulturner/LinSched.
Is this repo at the last version? I mean, is what follows still
true?

"Linsched does not verify locking in the scheduler code since its
execution is single threaded. Lock contention and other SMP artifacts
are also not captured in the simulation. Consequently performance
impacts due to these are not covered."

Thanks and Regards,

	Juri
