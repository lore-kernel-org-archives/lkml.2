Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab1KHXHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:07:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54312 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1KHXHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:07:03 -0500
Date: Tue, 8 Nov 2011 17:06:56 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH pm 1/2] usb_storage: don't use set_freezable_with_signal()
Message-ID: <20111108230656.GD1590@thinkpad-t410>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20111101003726.GM18855@google.com>
 <20111101164010.GA19686@thinkpad-t410>
 <20111101164351.GT18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101164351.GT18855@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 09:43:51AM -0700, Tejun Heo wrote:
> On Tue, Nov 01, 2011 at 12:40:10PM -0400, Seth Forshee wrote:
> > That looks like it ought to work, and it's definitely less convoluted
> > than what's there now.  I'd be happy to test it next week when I'm back
> > home and have access to the machine that prompted the original change.
> 
> Awesome.  Thanks a lot.

Your changes are working great in my testing.

Acked-by: Seth Forshee <seth.forshee@canonical.com>
