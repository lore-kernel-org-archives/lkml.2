Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1AURlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:41:10 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58032 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab1AURlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=YgNKdV1En6pSlbxXR6R+Gk6js17PblfdYisvwn7aH4ISL33faQlYfsGn5uLwiFYD0D
         z540NotqKT9WSeyCkKIZgsm1t6HyUkIdUg7CTY1sfA04WfIt1eN2Hl9jtHrTUrHj3aYp
         BXGVM6IwkJp+BZeDxbXbukcOJigCS3eR06IMM=
Date: Fri, 21 Jan 2011 15:40:55 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: "Dr. David Alan Gilbert" <david.gilbert@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mingo@elte.hu, dave.martin@linaro.org
Subject: Re: [PATCH] fix perf Annotation of Thumb code
Message-ID: <20110121174055.GD15066@ghostprotocols.net>
References: <20110121163922.GA31398@davesworkthinkpad>
 <4D39BF9E.3030007@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D39BF9E.3030007@ru.mvista.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 21, 2011 at 08:17:18PM +0300, Sergei Shtylyov escreveu:
> >(For reference this corresponds to this bug
> >https://bugs.launchpad.net/linux-linaro/+bug/677547 )
> 
> >        Signed-off-by: Dr. David Alan Gilbert <david.gilbert@linaro.org>
> 
>    Hm, I think there should be no spaces/tabs before signoff...
> 
> >+			sym.st_value-=1;
> 
>   The coding style used suggests spaces around -=.
> 
> WBR, Sergei

I noticed both issues and will fix them up when applying the patch.

Thanks

- Arnaldo
