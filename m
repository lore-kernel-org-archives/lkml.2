Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab0ISK2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 06:28:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55939 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0ISK2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 06:28:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oFHNTeSTwNEEVWB91a89pEoY1P7M3JHM06PIpGT/x5LF8s5heHgtXbJ/JPbo/fgsqh
         oSINHtJTtTalvjbNxKT+5uZuXmXP2AAeGG5vYepunT97FvuKLgLx2+ZVj+/jt8nv2sC6
         Q3WywviBZNreP6IK8j/ZyL3swwbJ2ndFgjgrM=
Subject: Re: ahci rmmodable and shouldn't
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
In-Reply-To: <4C933A8F.2080305@gmail.com>
References: <201009162256.04765.pedrogfrancisco@gmail.com>
	 <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net>
	 <4C933A8F.2080305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 11:28:26 +0100
Message-ID: <1284892106.2650.4.camel@sundae-v2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sex, 2010-09-17 at 11:53 +0200, Tejun Heo wrote:
> Just don't rmmod a module which is serving a live filesystem.  Why
> does it even matter?
> 

... Ok, let me argue another way. What if my mail was called: «lsmod
shows false values ("Used by: 0") for module 'ahci'», would you agree it
was an error and should therefore be fixed?

-- 
Pedro

