Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3AFJgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 04:36:54 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:55338 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3AFJgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 04:36:52 -0500
Date: Sun, 6 Jan 2013 10:36:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jonathan Kliegman <kliegs@chromium.org>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] modpost: Add flag -f for making section mismatches
	fatal
Message-ID: <20130106093649.GA17429@merkur.ravnborg.org>
References: <1356029364-11346-1-git-send-email-kliegs@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356029364-11346-1-git-send-email-kliegs@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan.

> The section mismatch warning can be easy to miss during the kernel build
> process.  Allow it to be marked as fatal to be easily caught and prevent
> bugs from slipping in.
> 
> Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>

Another way to make them much more visible would be to make
the warnings always be verbose.

In other words drop support for the "-S" options used below:
>   $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S) 

Previously the dev* stuff caused a lot of warnings, but
since we have HOTPLUG always enabled this is a non-issue.
So I think that this is a good time to enable the verboce
warnings.

	Sam
