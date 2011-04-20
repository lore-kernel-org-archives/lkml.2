Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1DTJZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:25:09 -0400
Received: from linux-sh.org ([111.68.239.195]:33143 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab1DTJZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:25:08 -0400
Date: Wed, 20 Apr 2011 18:25:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Waychison <mikew@google.com>
Cc: Peter Jones <pjones@redhat.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efifb: Fix "cast to pointer from integer of different size"
Message-ID: <20110420092500.GD15898@linux-sh.org>
References: <1303245483-2799-1-git-send-email-mikew@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303245483-2799-1-git-send-email-mikew@google.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 01:38:03PM -0700, Mike Waychison wrote:
> Fix set_system() to not cause a cast warning when printing a u32 as a
> pointer:
> 
> drivers/video/efifb.c: In function 'set_system':
> drivers/video/efifb.c:247: error: cast to pointer from integer of
> different size
> 
> Allow the integer to print as a pointer by first casting to unsigned
> long which we know will be the width of a pointer and at least as wide
> as u32.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>

I've already taken another patch that fixed it a slightly different way,
thanks anyways.
