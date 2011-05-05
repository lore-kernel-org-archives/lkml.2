Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab1EEQLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 12:11:51 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:38076 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1EEQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 12:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jsJEUx+Cz4PYGbxM8+Jn6CCKFk7ahwmFYvjO3kG282QDEHbbnz0/tRLanJN3cJlTsu
         U3hKxqG1whmTc5E9UL5QJsAQJ9CPNif+yqvGx/hyPsWYXkYfWwzpP/MoKzKLF2TSyaJB
         PK8UcVwH/C3+vx6BMMscO2/A6C9zkWWqdDLLI=
Date: Thu, 5 May 2011 09:11:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] arch/tile: finish enabling support for TILE-Gx 64-bit
 chip
Message-ID: <20110505161143.GE27251@core.coreip.homeip.net>
References: <201105042004.p44K4rPS011723@farm-0032.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105042004.p44K4rPS011723@farm-0032.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 02:38:26PM -0400, Chris Metcalf wrote:
> 
> Finally, I had to hack the existing hacky drivers/input/input-compat.h
> to add yet another "#ifdef" for INPUT_COMPAT_TEST (same as x86_64).

That change looks fine, please feel free to merge with the rest.

-- 
Dmitry
