Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1EXOz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:55:57 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:35803 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1EXOz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:55:56 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Tue, 24 May 2011 15:55:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-28-generic; KDE/4.6.2; x86_64; ; )
Cc: Denys Vlasenko <vda.linux@googlemail.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <201105241336.04298.pedro@codesourcery.com> <20110524140215.GF10334@htj.dyndns.org>
In-Reply-To: <20110524140215.GF10334@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241555.47282.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 May 2011 15:02:15, Tejun Heo wrote:
> Now that thinking more about it, TRAP_STOP (INTERRUPT trap) would
> probably be better.  I'll think more about it.  For fork, it doesn't
> really matter but deliverying SIGSTOP on CLONE isn't too good.  From
> user's POV, TRAP_STOP should work too, right?

AFAICS, it should be no problem.

Thanks,
-- 
Pedro Alves
