Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab0HEDWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:22:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56874 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674Ab0HEDWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U6+EfsE2ByheOss1fycHA8ia3uwnAZSXykmfQ2bAfXVSwYD93HWnn16auy+NqxDIdy
         /lLP+yFe9TOWCRyLLIjTp1/5voF3gmkSj9qtAwrulmm/tnPs5ykQPiRAdYmahWugrouj
         W9G6mGxmUhffAsFdbrOjpiSvaPlPQIAuPJqTw=
Date: Thu, 5 Aug 2010 11:26:58 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Michael Neuling <mikey@neuling.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Simon Horman <horms@verge.net.au>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] Merge kexec-tools into the kernel tree
Message-ID: <20100805032658.GB5235@cr0.nay.redhat.com>
References: <20100804070647.GB24064@verge.net.au>
 <m17hk6de62.fsf@fess.ebiederm.org>
 <30114.1280963486@neuling.org>
 <m1vd7q0vsx.fsf@fess.ebiederm.org>
 <5789.1280971186@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5789.1280971186@neuling.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 11:19:46AM +1000, Michael Neuling wrote:
>> If we talk about analyzing and filtering crash dumps, I can totally
>> see an argument for putting something under tools/ if the authors of
>> mkdumpfile and crash are interested.  Those tools fundamentally really
>> do follow kernel internals.
>
>I agree that the argument is stronger for tools/ inclusion if internal
>APIs need to be followed.  Of course perf doesn't need internals APIs
>and it's in tools/.
>

Well, I don't remember clearly why perf was proposed to be included into
kernel tree by Ingo, I think it was internal API/ABI issue as well.
