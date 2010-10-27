Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541Ab0J0ILg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:11:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55205 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0J0ILd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=SKdlE6F8vohqNZjrT/z1Goy8oWad4KmQJzhRkhdKqlaE2sPwExvO53i57+MbuWre0y
         snt/mXsgGNTGexoAyfdsKe6I1vPuCa5E5/1SoruIRwjei+HMlcFKZ7xl53cseEkekw1F
         hinzLG/jZ5vkEWU3jTV0CQ5WbHanAoTzaFkhg=
Date: Wed, 27 Oct 2010 10:11:21 +0200
From: Dan Carpenter <error27@gmail.com>
To: walter harms <wharms@bfs.de>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Julia Lawall <julia@diku.dk>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/14] drivers/platform/x86/thinkpad_acpi.c: delete
	double assignment
Message-ID: <20101027081121.GC6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	walter harms <wharms@bfs.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1288088743-3725-1-git-send-email-julia@diku.dk> <1288088743-3725-9-git-send-email-julia@diku.dk> <20101027010908.GA29299@khazad-dum.debian.net> <4CC7D238.9010903@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7D238.9010903@bfs.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 09:18:16AM +0200, walter harms wrote:
> 
> IMHO that goes beyond what to expect from a kernel janitor.

No way!  Of course, we don't mindlessly remove the second assign without
trying to figure out if maybe something else was intended.  Frankly, I
was a little offended by idea that we'd do that.

Of course, we do make mistakes, but they're _honest_ mistakes.

regards,
dan carpenter

