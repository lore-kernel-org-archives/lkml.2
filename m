Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0L3UbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 15:31:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65108 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab0L3UbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 15:31:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :organization:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=LAVo7OFruKphIiJLGuEYKe1rkLffh0xlU7cc7+V+kVK8P6DN5mcf2huSY7KtIzW19a
         FLe6YfmrEhxY59hBMNbD6xEnhSEKAGXizXvmMdhAQPolzVOU/BJ5Pd4siORJ/h6Br5o8
         keiH7NrVSZCv4m0p1G5HFf7Kh8UYnxqECkS5Y=
From: webmaster <jason.vas.dias@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: per-chroot clock module ?
Date: Thu, 30 Dec 2010 20:31:15 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.36.2-jvd+; KDE/4.3.4; x86_64; svn-1073138; 2010-01-11)
Cc: linux-kernel@vger.kernel.org
References: <201011271821.35039.jason.vas.dias@gmail.com> <20101203193658.GB2371@ucw.cz>
In-Reply-To: <20101203193658.GB2371@ucw.cz>
Organization: Text2Car Inc.
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012302031.15545.webmaster@www.text2car.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 December 2010 19:36:59 Pavel Machek wrote:
> Hi!
> 
> > I'd really like to be able to set a distinct "clock" for a specific chroot environment, 
> > such that the super-user could call :
> >    const char *my_chroot_directory = "/some_chroot";
> >    struct stat st;
> >    if(stat( my_chroot_directory, &st) ==0)
> >          sys_clock_settime ((clockid_t) st.st_inode,  (struct timespec *)tp)
> >    ( from glibc )
> 
> See subterfugue.net... it can do this.
> 
Sorry for the delay in responding - 
but I've been very busy, amongst other things working on the "per-chroot" module, which
now works in a very basic but sufficient mode.
If anyone else would find it useful,  I'll fill it out some more and post it to this list. 

I'd like to see this "subterfuge.net" - but I'm unable to connect with HTTP:
  
$ curl http://subterfuge.net --trace-ascii /dev/fd/2
== Info: About to connect() to subterfuge.net port 80 (#0)
== Info:   Trying 184.82.15.90... == Info: No route to host
== Info: couldn't connect to host
== Info: Closing connection #0
curl: (7) couldn't connect to host

while google just finds "subterfuge.com" which appears to be a Spanish record company ...
Is this server now down / being blocked ? 
Did I get the URL incorrect ? What is / was the software at subterfuge.net ?

All the best & happy new year to all ,
Jason
