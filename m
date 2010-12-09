Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0LIWmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:42:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42106 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab0LIWmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:42:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] ACPI: Bug compatibility for Windows on the ACPI reboot vector
Date: Thu, 9 Dec 2010 23:41:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, x86@kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org
References: <1291931204-5854-1-git-send-email-mjg@redhat.com> <1291931204-5854-3-git-send-email-mjg@redhat.com> <4D0159EA.90303@zytor.com>
In-Reply-To: <4D0159EA.90303@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012092341.36260.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 09, 2010, H. Peter Anvin wrote:
> On 12/09/2010 01:46 PM, Matthew Garrett wrote:
> > Windows ignores the bit_offset and bit_width, despite the spec requiring
> > that they be validated. Drop the checks so that we match this behaviour.
> > Windows also goes straight for the keyboard controller if the ACPI reboot
> > fails, so we shouldn't sleep if we're still alive.
> >
> > Signed-off-by: Matthew Garrett<mjg@redhat.com>
> 
> Be careful: the goal isn't bug-compatibility with Windows, the goal is 
> to work on the maximum number of systems.  Bug-compatibility with 
> Windows *may* be a way to that goal, but it is not a guarantee, since 
> Windows doesn't get validated against older systems that went through 
> WHQL under an earlier version of Windows.

Agreed.

Rafael
