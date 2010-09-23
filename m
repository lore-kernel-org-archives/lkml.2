Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab0IWPoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:44:18 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35916 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0IWPoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j2AL9nuluuqyqypS/GZmtgqE6hMK1Mci6gP3T5AINdQxmF+DwyYFz97h0AaFsOi8pP
         ov1bVUUOXTxWPaRl1gFmSQKP/D613LsYpbrK9FG4WYwBvqbv59FEzmQ+aa6Hyz6Le2XR
         5OFwJ+pW3HS5vWJ9gghvHnGE58Iovb/JbvFGA=
Date: Thu, 23 Sep 2010 08:44:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: for best practices, return -ENOMEM instead of -1
 when returning on mem allocation errors
Message-ID: <20100923154407.GA17807@core.coreip.homeip.net>
References: <1285251245.2127.4.camel@cowboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285251245.2127.4.camel@cowboy>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 10:14:05AM -0400, Davidlohr Bueso wrote:
> input: for best practices, return -ENOMEM instead of -1 when returning on mem allocation errors.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Applied, thank you Davidlohr.

FWIW there are more code in drivers/input/serio and drivers/input/mouse/
that return -1 instead of a proper error codes.

-- 
Dmitry
