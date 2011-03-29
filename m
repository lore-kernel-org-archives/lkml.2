Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1C2Gdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:33:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37719 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab1C2Gds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W3J9plMpgA0i8tfXL4NNXAFje0NiAfMgbJyCwDFebD6RRDNKz6gU1bKZpoglpv4Z5x
         a30JyvwHKpBtAdoI7bLBaqPuW9Nx+CU0b2OAMiNkckt8tiUyYMVMSawhPxhtXkaCrv4r
         LfRN1XytLTgQKekFFEs+jn3b8pqUEwQOOWpWM=
Date: Mon, 28 Mar 2011 23:33:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110329063341.GA26490@core.coreip.homeip.net>
References: <AANLkTi=U2Qkqv7FKfe18f0a=8Xg0QwRX_cxFj-j7ZPC=@mail.gmail.com>
 <1301337224-3293-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301337224-3293-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 01:33:41PM -0500, Seth Forshee wrote:
> On Mon, Mar 28, 2011 at 02:14:33PM +0000, Corentin Chary wrote:
> > But since Dmitry and Chris seems to prefer the autorepeat approach
> > with a single key code, if it works then it's ok, we just need to set
> > REP_DELAY, report press and release events, and drop 0xea events.
> 
> New patches follow. I didn't set REP_DELAY (or REP_PERIOD) because the
> input core interprets this to mean that the driver will handle the
> autorepeat itself. There's always EVIOCSREP to change the delay and
> repeat period from userspace.

Just an FYI: it is perfectly fine to set custom REP_DELAY and REP_PERIOD
after registering an input device.

Thanks.

-- 
Dmitry
