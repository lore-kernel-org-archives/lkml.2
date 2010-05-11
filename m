Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab0EKF7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 01:59:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092Ab0EKF7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 01:59:42 -0400
Date: Mon, 10 May 2010 22:57:25 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>, Pavel Machek <pavel@ucw.cz>,
       Pavel Herrmann <morpheus.ibis@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch]hp_accel: Fix race in device removal
Message-Id: <20100510225725.6bfdc4a5.akpm@linux-foundation.org>
In-Reply-To: <201005110755.07717.oneukum@suse.de>
References: <201005071804.20462.oneukum@suse.de>
	<20100510154632.bbe181d8.akpm@linux-foundation.org>
	<201005110755.07717.oneukum@suse.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 07:55:07 +0200 Oliver Neukum <oneukum@suse.de> wrote:

> Am Dienstag, 11. Mai 2010 00:46:32 schrieb Andrew Morton:
> > But alas, I (and presumably others) cannot confirm that, because you
> > didn't describe the bug :( This also means that if someone hits a
> > problem with this driver, they won't easily be able to work out whether
> > this patch will fix it.
> > 
> > 
> > Under what circumstances does it trigger?
> > 
> > What are the observed effects when it triggers?
> > 
> > Please always include this sort of information when sending bugfixes, thanks.
> 
> Sorry,
> 
> the patch closes a window during which a work queue might remain
> active after the device is removed and would then lead to ACPI calls
> with undefined behavior.

Had anyone observed this in the field?  Was a machine crashing, perhaps?
