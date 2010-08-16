Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0HPSN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:13:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45846 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0HPSNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=lg6yPqv5o96+84Bf1dY9XXLezSwURK//zf+KoyMRQ+NORHIMGu1VOIqW4pFGI4l4H4
         qb84YNqWz49TBZDZFuJFWhi2Bp9L24fzgWIJyMHVGCYD2P1XwXhn1O0NT8+DfZSILq1q
         ZQ9iFCctjrnHtBqDI5vkrVTYe2wMvNZhyNbN0=
Date: Mon, 16 Aug 2010 20:13:06 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 15/16] drivers/platform/x86: Use available error codes
Message-ID: <20100816181305.GD645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>,
	Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
	Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1008161828350.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008161828350.19313@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 06:28:52PM +0200, Julia Lawall wrote:
> ---
> This changes the semantics and has not been tested.  In each case, error is
> also assigned to the result of a function call.  Perhpas that should be
> changed to result as well, and error should be eliminated.
> 

Yep.  That should be changed to result as well.

regards,
dan carpenter


