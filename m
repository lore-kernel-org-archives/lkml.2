Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0LFRDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:03:34 -0500
Received: from xenotime.net ([72.52.115.56]:38727 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752989Ab0LFRDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:03:33 -0500
Date: Mon, 6 Dec 2010 09:03:23 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Olaf van der Spek <olafvdspek@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Atomic non-durable file write API
Message-Id: <20101206090323.6b049846.rdunlap@xenotime.net>
In-Reply-To: <AANLkTikYF-V2WaEB3a04OhFuzOm2qjx3fWxJ6fOwED5T@mail.gmail.com>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
	<AANLkTikYF-V2WaEB3a04OhFuzOm2qjx3fWxJ6fOwED5T@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010 17:45:23 +0100 Olaf van der Spek wrote:

> On Mon, Nov 29, 2010 at 1:37 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> > Hi,
> >
> > Since the introduction of ext4, some apps/users have had issues with
> > file corruption after a system crash. It's not a bug in the FS AFAIK
> > and it's not exclusive to ext4.
> > Writing a temp file, fsync, rename is often proposed. However, the
> > durable aspect of fsync isn't always required and this way has other
> > issues.
> > What is the recommended way for atomic non-durable (complete) file writes?
> >
> > I'm also wondering why FSs commit after open/truncate but before
> > write/close. AFAIK this isn't necessary and thus suboptimal.
> 
> Somebody?
> --

maybe try linux-fsdevel@vger.kernel.org or linux-ext4@vger.kernel.org
mailing lists?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
