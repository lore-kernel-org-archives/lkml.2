Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab1FMMhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:37:33 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:40022 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1FMMhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OEunZUqjDbZeu1ME4GC2EPgv/zNrAr8yYNIfjtAwp6echnlC6uylj9or6tWCvFUXRt
         QlPP24C3jylpOtiKM/lgd0deJNVS9vo7HiMMI1cb/P/6j/GhikYd3o9bZqdohzIaFpEH
         GehQXAg4kDVlx2Q2ZaoUv1vJNoka5l5K/LN2Y=
Date: Mon, 13 Jun 2011 15:36:59 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] staging/easycap: Fix bytesperline calculation
Message-ID: <20110613123659.GG3583@shale.localdomain>
References: <cover.1307967011.git.kirr@mns.spb.ru>
 <bcbeb6b7c5ab7624ea59b072f74347fa8e6a6350.1307967011.git.kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcbeb6b7c5ab7624ea59b072f74347fa8e6a6350.1307967011.git.kirr@mns.spb.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It warms my heart to see a beautiful commit message like that,
complete with diagrams.  :)

> 
> P.S. why at all we use those mask/shifts? Why not use bitfields?

Because this is crap code from the staging dir.

regards,
dan carpenter

