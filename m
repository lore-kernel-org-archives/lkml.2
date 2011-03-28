Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab1C1UmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:42:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1C1UmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:42:20 -0400
Date: Mon, 28 Mar 2011 21:42:16 +0100
From: Steven Hardy <shardy@redhat.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: gregkh@suse.de, mjg@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] Fix memory leak in qcserial driver
Message-ID: <20110328204215.GA3035@shardy.csb>
References: <1301321186.4397.13.camel@shardy.csb>
 <20110328173422.GA6354@redhat.com>
 <20110328174811.GD7030@shardy.csb>
 <20110328175448.GR2526@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328175448.GR2526@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 01:54:48PM -0400, Aristeu Rozanski wrote:
> kfree(data) won't make data == NULL. it'll free whatever address data
> has. data will still have the same (now stale) address. you need to
> explicitely make data = NULL if you want that behavior.

Of course, sorry I should have remembered that, too much scripting lately's caused some brain-rot :)

I will resend a revised patch.

Thanks, 

Steve
