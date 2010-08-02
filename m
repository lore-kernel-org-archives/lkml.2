Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0HBWJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:09:12 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60024 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0HBWJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:in-reply-to:message-id:references:user-agent
         :x-archive:mime-version:content-type;
        b=DB1Ekldau8LDtZhnlqWpBOCRy5YcsPu/hr4AX5qotDJg+nWQKYwE57agPOpgIUIaMk
         8QgSviEIp7yFrZ33IQOJbWqpd6SoBWVt/3JeL6zuoVvmACOmCT0lyMxHeW/NqID+rZrs
         27kyMS7fObyMusCVsTHWzYZYYEZj9BpKfT1tY=
Date: Mon, 2 Aug 2010 19:09:04 -0300 (BRT)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
In-Reply-To: <7975590447314667432@unknownmsgid>
Message-ID: <alpine.LNX.2.00.1008021905460.8985@dyndns.pervalidus.net>
References: <1280716262.5125.42.camel@falcon.homelinux.org>  <201008012138.39036.bjorn.helgaas@hp.com> <1280722876.5125.83.camel@falcon.homelinux.org>  <201008020748.09968.bjorn.helgaas@hp.com> <7975590447314667432@unknownmsgid>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am I missing something ?

make[2]: *** No rule to make target `firmware/radeon/R100_cp.bin', needed by `__fw_modbuild'.  Stop.

Not sure if it's because I use O= during make, or because I 
always patch the kernel, instead of using the tarball every 
release, or something else.

In linux-2.6.35/firmware/radeon there are R100_cp.bin.ihex and 
other files dated 20091122. 2.6.34 and earlier never gave such 
error.
