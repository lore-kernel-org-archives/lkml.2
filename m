Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab0GLFND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 01:13:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:60636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab0GLFNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 01:13:00 -0400
Date: Sun, 11 Jul 2010 22:16:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2] pm: Add runtime PM statistics
Message-ID: <20100711221646.35f11b70@infradead.org>
In-Reply-To: <201007112326.07541.rjw@sisk.pl>
References: <20100710095254.5ab7291c@infradead.org>
	<201007112326.07541.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jul 2010 23:26:07 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > +
> >  static DEVICE_ATTR(runtime_usage, 0444, rtpm_usagecount_show,
> > NULL); static DEVICE_ATTR(runtime_active_kids, 0444,
> > rtpm_children_show, NULL); static DEVICE_ATTR(runtime_status, 0444,
> > rtpm_status_show, NULL); +static DEVICE_ATTR(runtime_active_time,
> > 0444, rtpm_active_time_show, NULL); +static
> > DEVICE_ATTR(runtime_suspended_time, 0444, rtpm_suspended_time_show,
> > NULL); static DEVICE_ATTR(runtime_enabled, 0444, rtpm_enabled_show,
> > NULL);
> 
> On a second thought, "active_time" and "suspended_time" should be
> sufficient (ie. the "runtime_" prefix is not really necessary).

it's not necessary but it's consistent with the others... so yes
I can change it but then it's no longer consistent naming.. are you sure
you want this changed?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
