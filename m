Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0CSAJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:09:54 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:65007 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab0CSAJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CAj0JGoLbOCZsRjbeEipt6te55Ji/UNmeWaXn+3qGbkAdW1QOKYY3EKvoAud14701B
         +mIquUGgwdUQfHtpxXvEB4CsM5LHwL7OunNP0p0rQI5gU/IpKYtyP6bFL7yZr+psjx9D
         vsGEsC+vmeV+wu/z0M9yb/7dxwae301zpcxJM=
Date: Thu, 18 Mar 2010 17:09:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] Input: implement sysrq as an input handler
Message-ID: <20100319000931.GA5671@core.coreip.homeip.net>
References: <20100317061952.GA19789@core.coreip.homeip.net>
 <20100319000043.GC12017@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319000043.GC12017@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 09:00:43PM -0300, Henrique de Moraes Holschuh wrote:
> Any chance of the user being able to avoid the SysRQ events getting to the
> handle, e.g. by opening the input device in exclusive mode or something like
> that?
>

Yes, it is a possible to suppress SysRq by grabbing an input device.
This possibility exisst with the current implementation too though -
after all legacy keyboard driver implemented as an input handler as
well.

... or am I answering a question different from the one you asked? ;)
 
-- 
Dmitry
