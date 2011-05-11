Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab1EKWmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:42:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55587 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab1EKWmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A9k9aAOrKGHV2sc5O7UicpEyClfy31dfOUgb5opiIxFsTvvVJIdnaeXFRx6WjMUYCF
         gKTOFtWSmswfYCuRSKIf5cKFITMiF6DzFD+d7zdO7NJEVIWxAAnhsV/M2yD+oJ/QWhlU
         +LqO7p1WQmZVMkv8Ce6mk5A0GSE3Go6wZ/3iY=
Date: Wed, 11 May 2011 15:42:25 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] input: remove useless synchronize_rcu() calls
Message-ID: <20110511224225.GF11178@core.coreip.homeip.net>
References: <1305149155.3232.11.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305149155.3232.11.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:25:55PM +0200, Eric Dumazet wrote:
> There is no need to call synchronize_rcu() after a list insertion,
> or a NULL->ptr assignment.
> 
> However, the reverse operations do need this call.

Applied, thanks Eric.

-- 
Dmitry
