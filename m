Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2CLRNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab2CLRNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:13:47 -0400
Subject: Re: linux-next: manual merge of the cpuidle-cons tree with the tip
 tree
From: Steven Rostedt <srostedt@redhat.com>
To: Rob Lee <rob.lee@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <CAMXH7KHdfzjZCsBMkFOnwYtyaqBztMY99QcZ7VwLP0JASUiVAw@mail.gmail.com>
References: <20120309184041.bd10edffa51dcd43ce069487@canb.auug.org.au>
	 <1331300109.1149.17.camel@fedora>
	 <CAMXH7KHdfzjZCsBMkFOnwYtyaqBztMY99QcZ7VwLP0JASUiVAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 12 Mar 2012 13:13:23 -0400
Message-ID: <1331572403.1149.19.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 12:06 -0500, Rob Lee wrote:

> 
> Looks good to me as well.
> 
> Who should carry this fixup?

I think it's trivial enough that Linus can handle it. He always said
that he likes to fix merge conflicts and has yelled at people who did
things to prevent them.

-- Steve


