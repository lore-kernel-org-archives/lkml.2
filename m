Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab0GMVaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:30:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549Ab0GMVa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:30:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH v2] pm: Add runtime PM statistics
Date: Tue, 13 Jul 2010 23:28:28 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <tom.leiming@gmail.com>
References: <20100710095254.5ab7291c@infradead.org> <201007112326.07541.rjw@sisk.pl> <20100711221646.35f11b70@infradead.org>
In-Reply-To: <20100711221646.35f11b70@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007132328.28853.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 12, 2010, Arjan van de Ven wrote:
> On Sun, 11 Jul 2010 23:26:07 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > +
> > >  static DEVICE_ATTR(runtime_usage, 0444, rtpm_usagecount_show,
> > > NULL); static DEVICE_ATTR(runtime_active_kids, 0444,
> > > rtpm_children_show, NULL); static DEVICE_ATTR(runtime_status, 0444,
> > > rtpm_status_show, NULL); +static DEVICE_ATTR(runtime_active_time,
> > > 0444, rtpm_active_time_show, NULL); +static
> > > DEVICE_ATTR(runtime_suspended_time, 0444, rtpm_suspended_time_show,
> > > NULL); static DEVICE_ATTR(runtime_enabled, 0444, rtpm_enabled_show,
> > > NULL);
> > 
> > On a second thought, "active_time" and "suspended_time" should be
> > sufficient (ie. the "runtime_" prefix is not really necessary).
> 
> it's not necessary but it's consistent with the others... so yes
> I can change it but then it's no longer consistent naming.. are you sure
> you want this changed?

No, you're right, sorry.

But can you rebase your patch on top of linux-next, please, and move the
definitions of the new attributes next to 'control' and 'runtime_status' (so
that they don't depend on 'debug')?

Rafael
