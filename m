Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab2JXGvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:51:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50395 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab2JXGvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:51:18 -0400
MIME-Version: 1.0
In-Reply-To: <20121024054236.GA14826@kroah.com>
References: <1351046993-2220-1-git-send-email-ming.lei@canonical.com>
	<20121024031845.GA11255@kroah.com>
	<CACVXFVNAWcNgf94mY24c7r2jwtciekz=N-Yw_PyY9-4sT+BL_Q@mail.gmail.com>
	<20121024054236.GA14826@kroah.com>
Date: Wed, 24 Oct 2012 14:51:16 +0800
Message-ID: <CACVXFVPB6Vn5rh51DLBS_DpYXD4x7rkxPrk1_uLtRBGndBcdXA@mail.gmail.com>
Subject: Re: [PATCH 2/2] firmware loader: introduce kernel parameter to
 customize fw search path
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 1:42 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> Yes, but why?  Let's not overdesign this, get the basics working and
> then, if someone really needs it, we can add it.

OK, I will remove the kernel parameter and related documentation,
and just keep it as module parameter, sorry about that.


Thanks,
--
Ming Lei
