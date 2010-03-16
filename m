Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966309Ab0CPOc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:32:27 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:57895 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab0CPOcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:32:25 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2010 10:32:24 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=xAndz4fh9BYWSKLtX0lpAXrqtzybxDA8zyBkxvu0w2GMlsrb52aaiWDQFQfg1eJg4n
         PQPqwPUcWXjseRURovzWVmyy3Vx0xqWKBKIlAPUnSoppyq17mikEBK2MTFJS2EuAkGaX
         NXoPJEfX7ertY4h8X++PcaFc4If27YKiqT1tE=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Ferenc Wagner <wferi@niif.hu>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: RFC: direct MTD support for SquashFS
References: <87vdcwv139.fsf@tac.ki.iif.hu>
Date: Tue, 16 Mar 2010 15:26:33 +0100
In-Reply-To: <87vdcwv139.fsf@tac.ki.iif.hu> (Ferenc Wagner's message of "Tue,
	16 Mar 2010 14:38:02 +0100")
Message-ID: <87ljdsibqe.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ferenc" == Ferenc Wagner <wferi@niif.hu> writes:

 Ferenc> Hi,

 Ferenc> In embedded systems, SquashFS over MTD would be a considerable
 Ferenc> win, as that would permit configuring without CONFIG_BLOCK.
 Ferenc> Please find attached a naive patch against 2.6.33 for this.  It
 Ferenc> does not handle bad MTD blocks, that could be handled by gluebi
 Ferenc> (once you're willing to take the UBI overhead), or by a custom
 Ferenc> solution later.

 Ferenc> For now, 2.6.34 gained pluggable decompressors, so this patch
 Ferenc> does not apply anymore, though the main idea holds.  My
 Ferenc> questions: is the community interested in integrating something
 Ferenc> like this, should this patch transformed into something
 Ferenc> acceptable, or am I a total lunatic?  I don't know a thing
 Ferenc> about filesystem development, but willing to learn and
 Ferenc> refactor.  Comments welcome.

Nice, I have been thinking about that as well. What kind of size savings
are you getting with this?

CC'ing linux-embedded as this might be of interest there as well.

-- 
Bye, Peter Korsgaard
