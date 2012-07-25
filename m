Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab2GYOgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:36:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47386 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176Ab2GYOgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:36:15 -0400
Date: Wed, 25 Jul 2012 07:36:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Subject: Re: [PATCH] leds: triggers: send uevent when changing triggers
Message-ID: <20120725143610.GA28588@kroah.com>
References: <1343176370-5856-1-git-send-email-ccross@android.com>
 <CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 02:11:30PM +0800, Bryan Wu wrote:
> On Wed, Jul 25, 2012 at 8:32 AM, Colin Cross <ccross@android.com> wrote:
> > Some triggers create sysfs files when they are enabled.  Send a uevent
> > "change" notification whenever the trigger is changed to allow userspace
> > processes such as udev to modify permissions on the new files.
> >
> 
> This looks like an workaround only for led trigger, can we fix this in
> sysfs level?

How do you propose doing that?

greg k-h
