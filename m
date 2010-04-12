Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab0DLN3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 09:29:55 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64355 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0DLN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 09:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IbBsSLsDvspgAo+8UpbB/7N36M0DuqHMkjHj+FGKFA/KSkRKC/Ezofkh2g4SuU5vNh
         8DbvJvb3em+7800X9rel8kdXBW1hA6uzxRadmANYlAuBNBqU6UN5E3mPIeTWV3lfx3x5
         4Ro1dqfSH9mIg4UVlg+839KnmxAuXvAQC2ox4=
Date: Mon, 12 Apr 2010 21:33:03 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: make xconfig needs qt-mt according to error msg
Message-ID: <20100412133303.GA3104@hack>
References: <201004120755.15336.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004120755.15336.gene.heskett@verizon.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 07:55:15AM -0400, Gene Heskett wrote:
>Greetings all;
>
>Doing a make xconfig on mandriva 2010 fails because it needs qt-mt, and the 
>64 bit version doesn't supply it.
>
>Is there a work-around other than menuconfig?
>

How about 'make gconfig'?

-- 
Live like a child, think like the god.
 
