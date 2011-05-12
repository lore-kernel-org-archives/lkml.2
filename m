Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab1ELQsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:48:41 -0400
Received: from kroah.org ([198.145.64.141]:52506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758042Ab1ELQsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:48:39 -0400
Date: Thu, 12 May 2011 09:38:49 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 00/12] staging: usbip: miscellaneous code cleanup
Message-ID: <20110512163849.GA26585@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
 <20110511211401.GC4893@kroah.com>
 <BANLkTikjf9ZAthr3jTUkoUKGJt2UGS73Cg@mail.gmail.com>
 <20110511231843.GC7362@kroah.com>
 <BANLkTim_WZdmE31qjChg8u0M8RKzez3fqg@mail.gmail.com>
 <20110512053109.GA26926@kroah.com>
 <BANLkTikAVC6vR0SEu86fQ-9mwn9853Qgbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikAVC6vR0SEu86fQ-9mwn9853Qgbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:41:31PM -0700, matt mooney wrote:
> I resent two patches that don't rely on my pr_*() commit in a new
> thread. The other patches will be resent once I get the dev_*()
> changes in. But I will send in the userspace utility patch asap
> although I might have created a conflict with the perf patch I sent in
> earlier.

I've applied these two patches.

thanks,

greg k-h
