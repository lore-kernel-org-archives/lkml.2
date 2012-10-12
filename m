Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2JLHdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 03:33:14 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:33775 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab2JLHdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 03:33:11 -0400
Date: Fri, 12 Oct 2012 09:33:09 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cris: use kbuild.h instead of defining macros in
 asm-offset.c
Message-ID: <20121012073309.GG24942@axis.com>
References: <1349946058-26791-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349946058-26791-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 10:00:58AM +0100, James Hogan wrote:
> This is modelled on commits such as the one below:
> 
> Commit fc1c3a003edb8a6778e64e10ef671a38c76c969e ("sh: use kbuild.h
> instead of defining macros in asm-offsets.c") introduced in v2.6.26.

Looks good here, I'll take it into the CRIS tree. Thanks!

> Signed-off-by: James Hogan <james.hogan@imgtec.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
