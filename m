Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab0HBWe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:34:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33622 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0HBWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:in-reply-to:message-id:references:user-agent
         :x-archive:mime-version:content-type;
        b=ehRPITN5aShLxltuKaYQy0lJXnx4tvKBWVjmzR2TjV8TDXCHXULQvgIzXE+4CY6FJi
         Arc8MGMF6c8f+mub5kK4NI405zEpA38eSiDYC0h/b8GJhYssY7L/YFp2ByMuHE0LEcN5
         Ld4ZM7MVBvz8nscAdduipALKHsNP9S+nJcGCA=
Date: Mon, 2 Aug 2010 19:34:18 -0300 (BRT)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
In-Reply-To: <alpine.LNX.2.00.1008021905460.8985@dyndns.pervalidus.net>
Message-ID: <alpine.LNX.2.00.1008021933360.8985@dyndns.pervalidus.net>
References: <1280716262.5125.42.camel@falcon.homelinux.org>  <201008012138.39036.bjorn.helgaas@hp.com> <1280722876.5125.83.camel@falcon.homelinux.org>  <201008020748.09968.bjorn.helgaas@hp.com> <7975590447314667432@unknownmsgid>
 <alpine.LNX.2.00.1008021905460.8985@dyndns.pervalidus.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1824723376-1280788464=:8985"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1824723376-1280788464=:8985
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 2 Aug 2010, Frédéric L. W. Meunier wrote:

> Am I missing something ?
>
> make[2]: *** No rule to make target `firmware/radeon/R100_cp.bin', needed by 
> `__fw_modbuild'.  Stop.
>
> Not sure if it's because I use O= during make, or because I always patch the 
> kernel, instead of using the tarball every release, or something else.
>
> In linux-2.6.35/firmware/radeon there are R100_cp.bin.ihex and other files 
> dated 20091122. 2.6.34 and earlier never gave such error.

Well, I guess the problem is make 3.82. It worked with 3.81.
--8323328-1824723376-1280788464=:8985--
