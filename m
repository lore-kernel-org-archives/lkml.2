Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1BQM0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:26:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:44948 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab1BQM0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:26:09 -0500
Date: Thu, 17 Feb 2011 13:26:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        greg@kroah.com, stern@rowland.harvard.edu,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH v4 0/1] HID: Report Descriptor in Sysfs
In-Reply-To: <4D5B4E5D.5060101@signal11.us>
Message-ID: <alpine.LNX.2.00.1102171323590.2160@pobox.suse.cz>
References: <20110123225935.GB12488@kroah.com> <1295841018-8561-1-git-send-email-alan@signal11.us> <4D5B4E5D.5060101@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Alan Ott wrote:

> > Using the /sys/class links, for hidraw devices, this puts a new file,
> > report_descriptor in the directory:
> > 	/sys/class/hidraw/hidraw0/device/
> 
> I Didn't get any responses on the fixed-up patch. Does anyone have any 
> issue with this?

I have applied the patch, thanks Alan.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
