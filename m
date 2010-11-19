Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0KSTRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:17:14 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41959 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab0KSTRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:17:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PmnFH+hTnzkk7xfX12XQFgHFMob3L7zUnKqaNxyf/j/1jDOdkKqv5bwzasGa3iSjGM
         Eo3wxwy8waO0qmOqh37TJ/Gi6vWW3jFob95Wk59JQcQIiTojW2hFpzUnl28+e8Hh11+N
         4Z0c95Js/3SqirCZjJvLuO9NTYeJisWcrmXHs=
Date: Fri, 19 Nov 2010 22:17:05 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Greg KH <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: core: do not put noninitialized devices
Message-ID: <20101119191705.GA12558@albatros>
References: <1290192100-11451-1-git-send-email-segoon@openwall.com>
 <20101119190242.GA14328@suse.de>
 <20101119191424.GA12273@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119191424.GA12273@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 22:14 +0300, Vasiliy Kulikov wrote:
> No, I've just analized the code.  Without device_initialize() ->kobj is
> not initialized:

I mean 'not set' instead of 'not initialized' - it is already kzalloc()'ed :)


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
