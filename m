Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0H2NIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:08:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54712 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0H2NIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=qykt0fWn5ZWuM9VfTuLmQk5VxzXVfDEBYAECt+oQcw8BozyP0S8uSj3F4iqUYefDCQ
         mSAWJFJ/lC9ee/fCBN+WQtYxA1jOBXGdeU0DWQjNVYFuC60QgZfk/TzNMhNrSjSipgJU
         GACEwJsgcXMbz3ZIFVruZK0PYo5uMMRYRhxQY=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] [2.6.36-rc2] hp-wmi: probe of hp-wmi failed with error -22
Date: Sun, 29 Aug 2010 15:08:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201008261949.12608.maciej.rutecki@gmail.com> <20100826175442.GA16305@srcf.ucam.org>
In-Reply-To: <20100826175442.GA16305@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008291508.08474.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 26 sierpnia 2010 o 19:54:42 Matthew Garrett wrote:
> On Thu, Aug 26, 2010 at 07:49:12PM +0200, Maciej Rutecki wrote:
> > Last known good kernel: 2.6.35
> > Failing kernel: 2.6.36-rc1, 2.6.36-rc2
> > 
> > Dmesg says:
> > root@gumis:/home/maciek# dmesg | grep -i hp-wmi
> > [    5.489731] hp-wmi: probe of hp-wmi failed with error -22
> 
> Should be fixed by a8ec105c0764c848d59f18a31f91fa00c99b2e7f

Thanks for the information.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
