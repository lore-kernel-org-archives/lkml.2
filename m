Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0IGJKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:10:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52921 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab0IGJK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:10:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IDw0nYcsCzv4Osv5HkaxUj+NrlqZMzzkOUtrcobNnaWHh9FqQrRtNTBmxM0j7v+8E+
         R+cQs+9XyGMOIvEA08QMv7rE6lHNJ57n6FlLMBacp1iHdymuIGgJFaM+dTuW6yfmiyWe
         kLOOB+fpiASMGfT+cZ7nXCL379/V2HQ+vaCc8=
MIME-Version: 1.0
In-Reply-To: <1281536463-10680-1-git-send-email-andy.shevchenko@gmail.com>
References: <1281536463-10680-1-git-send-email-andy.shevchenko@gmail.com>
Date: Tue, 7 Sep 2010 12:10:26 +0300
Message-ID: <AANLkTi=Ewb8xKMx_5rYxdBcM9w2W3_oxg8aJY=rb8SSr@mail.gmail.com>
Subject: Re: [PATCH] fs: use kernel's hex_to_bin() method
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 5:21 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
Any comments?


-- 
With Best Regards,
Andy Shevchenko
