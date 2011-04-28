Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1D1GZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 02:25:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50815 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1D1GZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 02:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ijhQBACHiJ6fzrLaTmzhz+jJPZ4Ff1A/GRkWhgm47hAojRbCmfTGbYb66rgwZLmNum
         k9gi/s1IXuuYey9bjnI6U9RmGJJgLqFYgPll8R8/4cHtzBxfVKcR0Nyx5gGzv+LcYoom
         dU3DNqx7OVIeExic8cfXt/44V48NzDAJFGeD4=
Date: Wed, 27 Apr 2011 23:25:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Bo Shen <voice.shen@atmel.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: qt1070 - Add MODULE_DEVICE_TABLE
Message-ID: <20110428062551.GC31734@core.coreip.homeip.net>
References: <1303658565.8556.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303658565.8556.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 11:22:45PM +0800, Axel Lin wrote:
> Adding the necessary MODULE_DEVICE_TABLE() information allows the
> driver to be automatically loaded by udev
> 

Applied, thanks Axel.

-- 
Dmitry
