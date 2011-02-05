Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1BEVIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 16:08:20 -0500
Received: from lo.gmane.org ([80.91.229.12]:60842 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab1BEVIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 16:08:19 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: Nikolaus Rath <Nikolaus@rath.org>
Subject: virt_to_page for userspace pointers (was: Reversing a memory mapping?)
Date: Sat, 05 Feb 2011 16:04:08 -0500
Message-ID: <878vxuxkfr.fsf@inspiron.ap.columbia.edu>
References: <87k4hgn8qa.fsf@inspiron.ap.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: ebox.rath.org
Mail-Copies-To: never
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Cancel-Lock: sha1:nIIXyvmfzFty+i23ga2KGptYb6g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikolaus Rath <Nikolaus@rath.org> writes:
> Is there a way that my own kernel module can "reverse" this mmap call?
> I.e. given the userspace pointer, how do I get access to the physical
> location of the memory that has been mapped?

Ok, after some studying I think I can ask the question in a better way:

Is there an equivalent function to virt_to_page (and virt_to_phys) that
works with userspace pointers? Or do I have to manually walk through the
page tables? In the later case, are there any examples of this kind of
search that I could use as a basis?


Thanks,

   -Nikolaus

-- 
 »Time flies like an arrow, fruit flies like a Banana.«

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C

