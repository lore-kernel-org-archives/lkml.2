Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab0IPWpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:45:50 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62299 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab0IPWpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=O/IrECy1Svzi+pbDSNh2eCBrYNpGYaJ3oXDBqaufWAbVZauRYbQ6MyoeT/CvLI2Ne+
         UlUUBpwuD0GrPc2FarwOAaZcqHmEUPo/oRorNGJwPXrsQvXs7xSgQv0dTGcVsKRa0eRB
         B6y0sG0f+d9cddXQC62LNt9dpV24Ms80YwZ2M=
MIME-Version: 1.0
In-Reply-To: <20100916193249.GD10397@kroah.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
	<20100916193249.GD10397@kroah.com>
Date: Fri, 17 Sep 2010 01:45:48 +0300
Message-ID: <AANLkTin_fs+moDjvd18H4QwMF1y0EXFq7tr3dq20JDoa@mail.gmail.com>
Subject: Re: [PATCHv2 01/10] staging: rt2860: change plain format of mac
 address to %pM in *printf()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 10:32 PM, Greg KH <greg@kroah.com> wrote:
> If so, care to send me the remaining pieces and I'll apply
> them?
Do I understand correctly I need to prepare correction series with
changes between v1 and v2?

P.S. In one patch in v1 series there was a typo as well.

-- 
With Best Regards,
Andy Shevchenko
