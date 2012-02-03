Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab2BCUSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:18:51 -0500
Received: from mail.vyatta.com ([76.74.103.46]:39185 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab2BCUSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:18:50 -0500
Date: Fri, 3 Feb 2012 12:18:47 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tags: fix regex passed to etags
Message-ID: <20120203121847.1b01f4b5@s6510.linuxnetplumber.net>
In-Reply-To: <4F2C38BD.1060109@codeaurora.org>
References: <20120203112701.1c12b12c@s6510.linuxnetplumber.net>
	<4F2C38BD.1060109@codeaurora.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Feb 2012 11:42:53 -0800
Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 02/03/12 11:27, Stephen Hemminger wrote:
> > Several of the regular expressions passed to etags where incorrect
> > and missing the backslash before the closing parenthesis, causing warning:
> >   etags: Unmatched ( or \( while compiling pattern
> >
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> >
> 
> I'm confused how ctags didn't complain at me. It worked for me when I
> tried it. Next time I'll try both. Thanks.
> 

Most likely a new check in newer version of the tags command.
