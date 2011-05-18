Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1ERQ3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:29:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50179 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab1ERQ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=JSVVgmyrSXkvi13hrYtVk24fVLziSUS89EGNLD9tlRYg1ENqNAQeGkbCiQgOSLQZim
         /znMzd1RnmWHw8xhrlJeJ7smwsXevcCO9sT0hGGX+juiyCASUH+x1fj9cKOyRQ3p1YeD
         mWMFZQBLo6PEPngQEY3KhY92Dgd8oj35utO4w=
From: Stevie Trujillo <stevie.trujillo@gmail.com>
To: Milton Miller <miltonm@bga.com>
Subject: Re: How to get backtrace? modprobe -r iwlagn; modprobe iwlagn kills kernel
Date: Wed, 18 May 2011 18:29:34 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.4-ck3; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105181637.46164.stevie.trujillo@gmail.com> <1305734101_6569@mail4.comsite.net>
In-Reply-To: <1305734101_6569@mail4.comsite.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105181829.34827.stevie.trujillo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 May 2011 17:55:01 Milton Miller wrote:
> On Wed May 18 2011 about 10:37:54 EST, Stevie Trujillo wrote:
> > I then tried kexec+crashkernel, but I only managed to get a backtrace
> > for the last panic (which I think is just a result of memory corruption
> > or something).  Finally I tried compiling ramoops into my kernel,
> > but it didn't want to load because of "No such device".
> 
> For the kexec+crashkernel, try to retrieve the kernel log buffer:
> 
> There are some macros available, but basically log_buf is a pointer
> to a buffer of length log_buf_len initialized to __log_buf (but can
> be expanded via the command line or sysctl, in). log_end is the
> end of the buffer.  If you haven't wrapped then just print log_end
> characters.

Thank you! This worked perfectly. I sent it to linux-wireless now.
