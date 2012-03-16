Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942Ab2CPNaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:30:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58225 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2CPNaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:30:14 -0400
Date: Fri, 16 Mar 2012 08:30:10 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] apple_bl: Add register/unregister functions
Message-ID: <20120316133010.GA25984@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org,
	Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
References: <1331847128-16339-1-git-send-email-seth.forshee@canonical.com>
 <1331847128-16339-2-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331847128-16339-2-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 04:32:07PM -0500, Seth Forshee wrote:
> +atomic_t apple_bl_register_count = ATOMIC_INIT(0);

Noticed that I forgot to make this static. I had also intended to rename
it; it was originally a reference count but I decided that didn't make
sense. I'll wait to see if there are any other comments. If this
otherwise looks okay I'll send an update for this patch.

Seth

