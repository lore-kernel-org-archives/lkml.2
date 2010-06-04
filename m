Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab0FDUsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:48:47 -0400
Received: from mail-yw0-f187.google.com ([209.85.211.187]:33857 "EHLO
	mail-yw0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0FDUso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GD2SLFQyla/w1DgzJNK8dvzuWaH9E1YEvElfX2qQdcRip4p94SwcRaBvjIN2AtiL1i
         SLopehVyUhehRGeoW6Q5alSOSqWHldMmBJ8FZUJ4KEqiIC3wG1qucaa7SHQk3rD2ILct
         9ZE/Lexck04tkFbElWAFJU9v5Qck0qEdsnLUM=
MIME-Version: 1.0
In-Reply-To: <20100604204455.GD19761@kroah.com>
References: <20100604204455.GD19761@kroah.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 4 Jun 2010 16:48:23 -0400
Message-ID: <AANLkTilwzoUlastS0M9OMKuWgwmDE3VXdf2LCJxf50dV@mail.gmail.com>
Subject: Re: [GIT PATCH] STAGING fixes and new drivers for 2.6.35-git
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 16:44, Greg KH wrote:
> apatard@mandriva.com (1):
>      staging: Add framebuffer driver for XGI chipsets

does the staging tree not require properly formatted git patches ?
-mike
