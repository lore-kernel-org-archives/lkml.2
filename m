Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1LMLqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 06:46:50 -0500
Received: from tango.0pointer.de ([85.214.72.216]:36187 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1LMLqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 06:46:48 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Dec 2011 06:46:47 EST
Date: Tue, 13 Dec 2011 12:38:46 +0100
From: Lennart Poettering <mzhcfgneg@0pointer.de>
To: James Hunt <james.hunt@canonical.com>
Cc: Upstart Devel List <upstart-devel@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Upstart 1.4 "Let them speak" released
Message-ID: <20111213113846.GE26355@tango.0pointer.de>
Mail-Followup-To: James Hunt <james.hunt@canonical.com>,
	Upstart Devel List <upstart-devel@lists.ubuntu.com>,
	linux-kernel@vger.kernel.org
References: <4EE738CA.8030409@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE738CA.8030409@canonical.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13.12.11 11:36, James Hunt (james.hunt@canonical.com) wrote:

Heya,

> * New "log" argument to console stanza allowing a system jobs
>   stdout/stderr to be captured to a file. New options added to
>   support this feature: '--default-console', '--logdir',
>   '--no-log'. This feature only currently applies to system jobs:
>   user jobs which specify "console log" will be treated as if they
>   had specified "console none".

Just out of curiosity: how is rotation handled for this? If you pass the
file fd directly to the spawned service you can't really rotate the file
ever, since you cannot ask the service to reopen the file. So what do
you do?

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
