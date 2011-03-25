Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1CYNkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:40:12 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56187 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1CYNkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:40:10 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: sparse-keymap - report KEY_UNKNOWN for unknown scan codes
Date: Fri, 25 Mar 2011 08:40:01 -0500
Message-Id: <1301060403-19229-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110325073554.GD2590@core.coreip.homeip.net>
References: <20110325073554.GD2590@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 12:35:54AM -0700, Dmitry Torokhov wrote:
> Hi Seth,
> 
> On Wed, Mar 23, 2011 at 04:13:43PM -0500, Seth Forshee wrote:
> >  
> > +	/* Report an unknown key event as a debugging aid */
> > +	unknown_ke.type = KE_KEY;
> > +	unknown_ke.code = code;
> > +	unknown_ke.keycode = KEY_UNKNOWN;
> > +	sparse_keymap_report_entry(dev, &unknown_ke, value, autorelease);
> 
> I think it should not depend on autorelease but always automatically
> release KEY_UNKNOWN.
> 
> Otherwise I think I'll apply both patches.

Great! Here are the patches with that changed.

