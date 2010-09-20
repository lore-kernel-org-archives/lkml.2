Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab0ITUoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:44:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54106 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab0ITUoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kbwDdsrzrKHoez//2c6CICYtrU1Lj9953wC4hYIf9039AVBZrLBSYOSfK4JfQ0VBJX
         N4zmo1HGtlMgHA9K66+Cpu7QmJpCiGsMuXAhTBf9ew3HJlDzN6gHY293czSDucj5eDRg
         5X7E24p0dGAh/vXPpDUgo6vYyqw76B2EJuYbc=
Subject: Re: ahci rmmodable and shouldn't
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <4C972C60.8010506@gmail.com>
References: <201009162256.04765.pedrogfrancisco@gmail.com>
	 <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net>
	 <4C933A8F.2080305@gmail.com> <1284892106.2650.4.camel@sundae-v2>
	 <4C9602E4.4090007@gmail.com> <1284974726.11757.9.camel@sundae-v2>
	 <4C9729D7.70500@gmail.com>  <4C972C60.8010506@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 21:44:25 +0100
Message-ID: <1285015465.26023.10.camel@sundae-v2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Seg, 2010-09-20 at 11:41 +0200, Tejun Heo wrote:
> Hello, again.
> 
> Yeah, now I'm fairly sure I was spewing out complete bullshit.  Sorry
> about that.  Gees, why does spewing out bullshit always feel so right?
> Please feel free to call me an idiot.  Can you please try the
> following patch and see whether it changes the module counting
> behavior?
> 
> Thanks.
> 
-snip

To which tree shall I apply it? It currently fails both on Linus'
linux-2.6 and
git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata-dev.git .

