Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1EFBzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:55:40 -0400
Received: from kroah.org ([198.145.64.141]:48157 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab1EFBzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:55:39 -0400
Date: Thu, 5 May 2011 18:44:34 -0700
From: Greg KH <greg@kroah.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Jack Stone <jwjstone@fastmail.fm>, tim.gardner@canonical.com,
        linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] fbcon -- fix race between open and removal of
 framebuffers
Message-ID: <20110506014434.GA9383@kroah.com>
References: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com>
 <1304617307-7389-2-git-send-email-tim.gardner@canonical.com>
 <4DC30FFA.9030708@fastmail.fm>
 <BANLkTikG=6xyFg--u=M6HwH8yQExAauA8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikG=6xyFg--u=M6HwH8yQExAauA8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 04:09:44AM +0300, Anca Emanuel wrote:
> @Greg: This is stable material for 2.6.38
> link to the patch: http://is.gd/otIfGc

<form_letter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

thanks,

greg k-h

</form_letter>
