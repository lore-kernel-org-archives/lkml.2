Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0LJVtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:49:17 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:52726 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0LJVtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:49:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gQfFswSJZJ+VjDhzgPakCtbQtInoq+LFiecuCycYIUXeYM58drZhGkqnbPBnXRsyiG
         IihA7cmqd92rxUyY8gp5YqtoF2auo2T/9ucVR37m6S7AT/lVb5ihyzNKleXDTeLvOYyG
         BReI2tdL1/D/u6Sszs1AWjh42QtlhqKgoWA2k=
Date: Fri, 10 Dec 2010 13:49:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kgdboc,input: Fix regression with keyboard release key
 and early debugging
Message-ID: <20101210214906.GF1630@core.coreip.homeip.net>
References: <1292013643-699-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292013643-699-1-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 02:40:43PM -0600, Jason Wessel wrote:
> === NOTES excluded from the real commit ===
> 
> Dmitry, I added this commit into kgdb-next and I will send a pull
> request to Linus Monday, unless someone comes up with an objection or
> a different implementation.

Yes, I think it makes sense. Such an early oopses are unlikely to have
input devices fully bound anyway so they'll get "reset" natually.

Thanks.

-- 
Dmitry
