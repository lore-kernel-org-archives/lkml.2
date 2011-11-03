Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1KCKkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:40:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48535 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab1KCKkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:40:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH pm] freezer: fix wait_event_freezable/__thaw_task races
Date: Thu, 3 Nov 2011 11:43:13 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org
References: <20111101021511.GP18855@google.com> <201111030201.27551.rjw@sisk.pl> <CAOS58YN4eQ5qfGXCjciGKvv13boSKQJso2U=x5rLw8c7vNeGWQ@mail.gmail.com>
In-Reply-To: <CAOS58YN4eQ5qfGXCjciGKvv13boSKQJso2U=x5rLw8c7vNeGWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111031143.13836.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 03, 2011, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 2, 2011 at 6:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > OK, so I guess I should drop it from my linux-next branch?
> 
> Hmmm... yes, the preceding patches should be applied first and then
> this one. Any problems with earlier ones?

The only problem I currently have is to figure out what patches to apply
and in which order.  Care to help? ;-)

Rafael
