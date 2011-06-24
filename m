Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab1FXWSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:18:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9010 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1FXWSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=F9RZrDtjAkcjQ4NtZRQ5X44CeNbw4v0wa7LFuRVQ5FysX8FFpgIEWBdJEDsISHIhrH
         5xD1pcYFJlsOcTGi9WTw==
MIME-Version: 1.0
In-Reply-To: <20110623132957.GA8058@somewhere.redhat.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
 <BANLkTineKOcQDzMrCdmizOhUGz+cViTomA@mail.gmail.com> <20110623132957.GA8058@somewhere.redhat.com>
From: Paul Menage <menage@google.com>
Date: Fri, 24 Jun 2011 15:18:00 -0700
Message-ID: <BANLkTikiRfwtvwVmq+aGvzK38XcyGXgeFZjUkx+OmjAo2O0rjw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] cgroups: Start a basic rlimit subsystem
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 6:30 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Agreed about future rlimit options, but building a single purpose
> numtask subsystem looks a bit strange. Just because it looks too much
> single purpose.

Admittedly most subsystems do have more knobs and features, but I
don't think it's unreasonable for a subsystem to provide just a single
feature. In theory the overhead is going to be very low.

Paul
