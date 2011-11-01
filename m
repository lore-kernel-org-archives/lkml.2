Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1KAQn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:43:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63384 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1KAQn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:43:56 -0400
Date: Tue, 1 Nov 2011 09:43:51 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH pm 1/2] usb_storage: don't use
 set_freezable_with_signal()
Message-ID: <20111101164351.GT18855@google.com>
References: <20111101003726.GM18855@google.com>
 <20111101164010.GA19686@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101164010.GA19686@thinkpad-t410>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 12:40:10PM -0400, Seth Forshee wrote:
> That looks like it ought to work, and it's definitely less convoluted
> than what's there now.  I'd be happy to test it next week when I'm back
> home and have access to the machine that prompted the original change.

Awesome.  Thanks a lot.

-- 
tejun
