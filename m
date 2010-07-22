Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0GVG2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:28:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43593 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0GVG2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:28:50 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, nhorman@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [Patch] kexec: increase max of kexec segments and use dynamic allocation
References: <20100722061810.5659.87609.sendpatchset@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 21 Jul 2010 23:28:45 -0700
In-Reply-To: <20100722061810.5659.87609.sendpatchset@localhost.localdomain> (Amerigo Wang's message of "Thu\, 22 Jul 2010 02\:13\:55 -0400")
Message-ID: <m1wrso2foi.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> Currently KEXEC_SEGMENT_MAX is only 16 which is too small for machine with
> many memory ranges. Increase this hard limit to 1024 which is reasonably large,
> and change ->segment from a static array to a dynamically allocated memory.

???

This should be about segments in the executable being loaded.  What
executable has one segment for each range of physical memory?

Not that generalizing this is a bad idea but with a comment that
seems entirely wrong I am wondering what the problem really is.

Eric

