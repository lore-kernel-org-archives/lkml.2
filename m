Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2DWUj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:39:29 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:43145 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2DWUj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:39:28 -0400
Date: Mon, 23 Apr 2012 13:39:24 -0700
From: greg <gregkh@linuxfoundation.org>
To: yan <clouds.yan@gmail.com>
Cc: kernel <linux-kernel@vger.kernel.org>, message <message.get@gmail.com>
Subject: Re: [PATCH 2/4][Trivial] lib/kobject.c : Check parameter in
 kobject_set_name
Message-ID: <20120423203924.GB13075@kroah.com>
References: <1335000692.2188.10.camel@yan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335000692.2188.10.camel@yan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 05:31:24PM +0800, yan wrote:
> kobject_set_name is exported and is just a wrapper for kobject_set_name_vargs
> which does not check its parameter kobj. 
> So check this parameter in kobject_set_name.

I have the same objection to this patch, why is it needed?  All
in-kernel users do this properly, so the patch isn't needed.

Remember, kernel programming isn't always about being defensive.

greg k-h
