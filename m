Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0DUJTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:19:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36648 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751332Ab0DUJTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:19:45 -0400
Date: Wed, 21 Apr 2010 10:23:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hedi Berriche <hedi@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
Message-ID: <20100421102350.4c222e6b@lxorguk.ukuu.org.uk>
In-Reply-To: <4BCE5A73.3000904@sgi.com>
References: <4BCE579C.5070100@sgi.com>
	<4BCE5A73.3000904@sgi.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> of 32k will not be enough.  A system with 1664 CPU's, there are 25163 processes
> started before the login prompt.  It's estimated that with 2048 CPU's we will pass

Is that perhaps the bug not the 32K limit ? and does Tejun's work on work
queue sanity help avoid the need for this ?
