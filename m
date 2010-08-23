Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0HWIvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:51:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46696 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0HWIvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nZeK8UoBkPnYwAEmS5arWZsKGlifUnZDUTuaP0hNqp0g2cR49aPaotO9lorO9NQsT4
         eUuNaZKVld7VFNPEThefA64DeSCAIAGY1aOhn0kiG72O+E9TgYc0faGsJNP224CsISUm
         RwxCKRL8ZCuSQ8LS0blg2cRg4VGlqA0tiOyqQ=
Date: Mon, 23 Aug 2010 10:52:03 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] posix clocks: introduce syscall for clock tuning.
Message-ID: <20100823085203.GA18510@riccoc20.at.omicron.at>
References: <cover.1282550649.git.richard.cochran@omicron.at>
 <e253843e07ce5d15c2c8d11ce786bf979ed85ca5.1282550649.git.richard.cochran@omicron.at>
 <AANLkTi=HFyMpXEjpyHmL-79qzXLQWEfiW+KiJHnrJRW2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=HFyMpXEjpyHmL-79qzXLQWEfiW+KiJHnrJRW2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 04:22:58AM -0400, Mike Frysinger wrote:
> FYI, this is going to hit a conflict as i'm about to push out an
> update to wire up the new 2.6.36 syscalls

Thanks for the "heads up."  At this point, the patch is meant just to
generate discussion and feedback.

Thanks,
Richard
