Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1HWQ74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:59:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46912 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1HWQ7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:59:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110823004318.GA16599@kroah.com>
References: <CAO+b5-prWOxkXcKLM+KctdMjV9YhT8zyyBxjaR6ofnP944hGKw@mail.gmail.com>
 <20110823004318.GA16599@kroah.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 23 Aug 2011 18:59:31 +0200
X-Google-Sender-Auth: GLmY_OoSSjTsJ-Q0syXk9_cfwvE
Message-ID: <CAO+b5-qjGyxNtTRR5DAUgK5sacO6ib9q_tjZw7LM+JMX3j+fZA@mail.gmail.com>
Subject: Re: [PATCH] docs/driver-model: Document device.groups
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, rpearson@systemfabricworks.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 2:43 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Aug 16, 2011 at 10:00:07PM +0200, Bart Van Assche wrote:
> > Many drivers use device_create_file() where device.groups should be
> > used instead. This patch documents that and also removes the comments
> > about device classes since these should not be used in new code.
> >
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Randy Dunlap <rdunlap@xenotime.net>
> > ---
> >  Documentation/driver-model/device.txt |   78 +++++++++++++++------------------
>
> This patch doesn't apply to 3.1-rc3, what kernel did you make it
> against?
>
> Care to resend so it can be applied?

The patch was generated against a recent tree but was sent with the
wrong e-mail client. A detailed explanation can be found here:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5ce9f07bf1bed9a1f9886373ad0b149294f84c25.

I'll resend a slightly modified version of this patch - a version with
a refined commit message and that preserves more of the original text.

Bart.
