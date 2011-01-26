Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1AZRBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:01:30 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48634 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1AZRB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W1leaSFxQoBa2hI95A62zsby70eo2fMeAEd77/uYIfkG5Y4jZspWID0Qn3paXlPOrb
         spH6fhlQdDw7rsc+ARogFknI3sVi+afcpnnd7w61dyv7/gDAJu8boYKgj3TJ5X3NcK5H
         BrrNevWFr6mOgdZEBkxfX5n0Uz/tTRuLqNDKg=
Date: Wed, 26 Jan 2011 08:59:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, tomas.winkler@intel.com,
        johannes.berg@intel.com, gregkh@suse.de
Subject: Re: [PATCH V2] firmware_classs: change val uevent's type to bool
Message-ID: <20110126165941.GA29168@core.coreip.homeip.net>
References: <1296038012-16656-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296038012-16656-1-git-send-email-lliubbo@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 06:33:32PM +0800, Bob Liu wrote:
> Some place in firmware_class.c using "int uevent" define, but others use "bool
> uevent".
> This patch replace all int uevent define to bool.
> 
> Changes since V1:
> 	johannes: remove no-op

Actually what you removed is the only non-noop from your previous patch.
And changelog like this should go  below "---" separator so import
scripts ignore it.

Anyways,

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
