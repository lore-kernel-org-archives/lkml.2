Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1DGP2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:28:04 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54433 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1DGP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:28:03 -0400
Date: Thu, 7 Apr 2011 17:28:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: tip: New "Link:" tag to replace "LKML-Reference:"
Message-ID: <20110407152800.GA19652@merkur.ravnborg.org>
References: <4D9CE4AE.4090303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9CE4AE.4090303@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 03:09:50PM -0700, H. Peter Anvin wrote:
> Hi all,
> 
> At Linus' request, I have modified the tip-bot to recognize a new form
> of email archive references, which should work as clickable links.
> Instead of:
> 
> LKML-Reference: <message-id>
> 
> use, instead:
> 
> Link: http://lkml.kernel.org/r/message-id

If use of this grows outside plain linux-kernel development a
more generic name could make sense.

Suggestion:

    http://mid.kernel.org/r/message-id

mid for message-id.

	Sam
