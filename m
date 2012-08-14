Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2HNLgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:36:00 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:32809 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab2HNLf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:35:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAHP4M8WV64UMor_oU4UNgGx7P0Zet_M3yJrAZaCR+yYQmmeEYw@mail.gmail.com>
References: <CAHP4M8WV64UMor_oU4UNgGx7P0Zet_M3yJrAZaCR+yYQmmeEYw@mail.gmail.com>
Date: Tue, 14 Aug 2012 13:35:58 +0200
Message-ID: <CAFLxGvyxq5OdhJ7nnD3hP95ARmQ6MyRtgFBWYoT+2xOwxjF+LQ@mail.gmail.com>
Subject: Re: How to hack syscall-table, in kernel 2.6+ ?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Ajay Garg <ajaygargnsit@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 1:31 PM, Ajay Garg <ajaygargnsit@gmail.com> wrote:
> So, now as a developer, if I wish to hack into the syscall-table, and
> change the syscall-function-pointers to my custom-function-pointers
> (mainly for the reason of adding/preventing access to certain files,
> via Kernel-Loadable-Modules), what is the recommended way?

It has been unexported to stop exactly such crap.
Not do it.

-- 
Thanks,
//richard
