Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1DNXlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:41:37 -0400
Received: from kroah.org ([198.145.64.141]:59291 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab1DNXle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:41:34 -0400
Date: Thu, 14 Apr 2011 16:40:39 -0700
From: Greg KH <greg@kroah.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: [stable] [PATCH] Bluetooth: Fix HCI_RESET command
 synchronization backported to stable
Message-ID: <20110414234039.GC7442@kroah.com>
References: <1302623007-16402-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302623007-16402-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 08:43:27AM -0700, Justin P. Mattock wrote:
> backported to stable. did not have the time to compile test this, but patch applies.

It applies, but breaks the build.

Care to do this correctly so I can apply it?

thanks,

greg k-h
