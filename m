Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab1C2NmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:42:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51849 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab1C2NmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:42:15 -0400
Date: Tue, 29 Mar 2011 08:42:05 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] eeepc-wmi: Add support for T101MT Home/Express
 Gate key
Message-ID: <20110329134205.GA16557@thinkpad-t410>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Chris Bagwell <chris@cnpbagwell.com>,
	Matthew Garrett <mjg@redhat.com>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <AANLkTi=U2Qkqv7FKfe18f0a=8Xg0QwRX_cxFj-j7ZPC=@mail.gmail.com>
 <1301337224-3293-1-git-send-email-seth.forshee@canonical.com>
 <1301337224-3293-3-git-send-email-seth.forshee@canonical.com>
 <AANLkTi=QJzVt=tR2mUmaRwvhNz5eeV0BE1LB0-pCybNV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=QJzVt=tR2mUmaRwvhNz5eeV0BE1LB0-pCybNV@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 12:29:11PM +0000, Corentin Chary wrote:
> > +       { KE_KEY, HOME_PRESS, { KEY_CONFIG } },
> 
> What X11 key is mapped to KEY_CONFIG ?

XF86Tools.

I'm still not 100% confident in that choice though. It's one of the two
suggested by Dmitry. The other (KEY_DASHBOARD) only seems to be used for
the key on Mac keyboards that displays the OS X dashboard, which is some
kind of widget overlay on top of the desktop.

The other option I considered was KEY_CYCLEWINDOWS, which maps to
XF86RotateWindows. No one seemed to know for sure what its intended
purpose is, but in some cases at least it appears to be used to rotate
the desktop.

Seth

