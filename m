Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2DROJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:09:02 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44068 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2DROI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:08:59 -0400
X-Originating-IP: 217.70.178.131
X-Originating-IP: 94.192.232.89
Message-ID: <1334758134.8818.132.camel@novo.hadess.net>
Subject: Re: [PATCH] HID: hid-input: default HID_BATTERY_STRENGTH to no
From: Bastien Nocera <hadess@hadess.net>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, Richard Hughes <richard@hughsie.com>
Date: Wed, 18 Apr 2012 15:08:54 +0100
In-Reply-To: <20120418140517.GM19507@zod.bos.redhat.com>
References: <20120418140517.GM19507@zod.bos.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 10:05 -0400, Josh Boyer wrote:
> Commit 4f5ca836b "HID: hid-input: add support for HID devices reporting
> Battery Strength" added the CONFIG_HID_BATTERY_STRENGTH option to report
> the battery strength of HID devices.  The commit log explicitly mentions
> it not working properly with recent userspace, but it is default y
> anyway.  This is rather odd, and actually causes problems on real
> systems.
> 
> This works around Fedora bug
> https://bugzilla.redhat.com/show_bug.cgi?id=806295

Don't. The only bit of user-space that's broken is upower, and it's
getting a fixed release shortly.

Richard?

