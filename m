Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab0IPW0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:26:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56114 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab0IPW0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b8rfwKXCSXSsMJlm5UMj8WJSRVFqH941Mlte9G4aNhoMPrGv7hJteYMNKl4fBJjQKE
         2OFTXB0KzIoB80T9dBKSFKxiSo2zSEiUXq6j473zFAwGWfxFtWEsYsGkMYMWBfMJXQu4
         sCPPzf/fubum/cD23Fmsv4LVE60pLnPCydD5c=
MIME-Version: 1.0
In-Reply-To: <20100916193249.GD10397@kroah.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
	<20100916193249.GD10397@kroah.com>
Date: Fri, 17 Sep 2010 01:26:38 +0300
Message-ID: <AANLkTi=18H1YvN-KyKZ6tuaJ8HbYi4DDbEOYmKFtQqKY@mail.gmail.com>
Subject: Re: [PATCHv2 01/10] staging: rt2860: change plain format of mac
 address to %pM in *printf()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 10:32 PM, Greg KH <greg@kroah.com> wrote:
> Oops, I just took your first version of this series.  Was there any
> differences?  If so, care to send me the remaining pieces and I'll apply
> them?
Yep, there is common change from '&pointer[0]' notation to just
'pointer' as suggested by Joe Perches.


-- 
With Best Regards,
Andy Shevchenko
