Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0IVIlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 04:41:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55075 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab0IVIlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 04:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b/2aZp+Tt1zpWiiyBYy/0sEzI2AAYZ0QKZgdy8ojzZdLPEP7apvhVscECiuu7z1bOH
         nuSPQ+wFuxBPjRmCWSEIw7hV1ufAPu6pqj7NhTZsOFARxYbAmX8/TvV8ebLyjQKabzjS
         0SikD4fl8FV9oSQxL0UCAwejP9w7v56Ah5cCU=
MIME-Version: 1.0
In-Reply-To: <1284213395.2986.9.camel@mulgrave.site>
References: <1284212280-25944-1-git-send-email-andy.shevchenko@gmail.com>
	<1284213395.2986.9.camel@mulgrave.site>
Date: Wed, 22 Sep 2010 11:41:15 +0300
Message-ID: <AANLkTin8C-3ktNzDc1dz0wTrq0915BibZRdNR7O4L9fw@mail.gmail.com>
Subject: Re: [PATCH] drivers: scsi: remove private hex_to_bin() implementation
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 4:56 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> the hex_to_bin() is really to prevent open coded mistakes.  When the
> open coding pre-dates the hex_to_bin macro, I'm inclined to leave it
> alone unless it contains an actual bug.
It's also a matter of speed/size optimization. Nevertheless SCSI
subsystem already has such clean up.

-- 
With Best Regards,
Andy Shevchenko
