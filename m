Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab2FOPyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:54:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57158 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453Ab2FOPyS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:54:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120614191743.GA2721@kroah.com>
References: <1339656138-28060-1-git-send-email-ning.n.jiang@gmail.com>
	<20120614153730.GB17140@kroah.com>
	<201206142115.47601.rjw@sisk.pl>
	<20120614191743.GA2721@kroah.com>
Date: Fri, 15 Jun 2012 23:54:16 +0800
Message-ID: <CAH3Oq6Qt=JzCXJsZFNd8WrCFhiPazHomou+GbFpyQ8Lq34fOdA@mail.gmail.com>
Subject: Re: [PATCH] PM: Deprecate suspend/resume in device_driver
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/15 Greg KH <gregkh@linuxfoundation.org>:
> On Thu, Jun 14, 2012 at 09:15:47PM +0200, Rafael J. Wysocki wrote:
>> On Thursday, June 14, 2012, Greg KH wrote:
>> > On Thu, Jun 14, 2012 at 02:42:17PM +0800, ning.n.jiang@gmail.com wrote:
>> > > From: Ning Jiang <ning.n.jiang@gmail.com>
>> > >
>> > > Make suspend/resume callbacks in device_driver deprecated and scheduled
>> > > for removal since they are not used in PM core anymore.
>> > >
>> > > Legacy drivers who still use them need to move suspend/resume callbacks
>> > > to dev_pm_ops.
>> >
>> > How many complier warnings does this patch produce?
>> >
>> > Please fix them before submitting this patch.  The way kernel
>> > development is is that you fix the problems up with the api, you don't
>> > just mark them and hope someone else will do it for you.
>> >
>> > Sorry, I can't take this.
>>
>> Right.
>
> To provide a bit more "constructive" review, the proper thing is to fix
> up the whole kernel to never set these fields, and then just delete
> them.  Ning, feel free to start working on that task, it's a good one to
> accomplish and should be pretty well defined.

All right. I'm working on it.
