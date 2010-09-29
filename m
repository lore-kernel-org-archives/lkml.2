Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0I2A16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:27:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43226 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0I2A14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S3/u1RyntiixNUN36pY4PT0h0hYH3d6NSd0E9eYD3ju0UJry3ELDH0Q5vW+mln1n3g
         Afcyu7TIIGvD3m3aXYaQTcDbHkKhY1J4gEJsVWFJrPS9IZ4fUIUVoAc6lhJ7eyl6VrAm
         8b/YpZmoTbggs31gsPSBwy1nKLpaPPvtTDITQ=
MIME-Version: 1.0
In-Reply-To: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
Date: Wed, 29 Sep 2010 02:27:55 +0200
Message-ID: <AANLkTimFbxc7MGdirSzdJ-YZbFFHBVn4JJhHcP46W1_4@mail.gmail.com>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
From: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/9/29  <akpm@linux-foundation.org>:
> The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to

I wonder why are these two functions in include/linux/fs.h
static inline void lock_flocks()
{
}

static inline void unlock_flocks()
{
}

Was there any contest for function, which will cause many warnings?

I'm getting an awful lot of
  CC      kernel/trace/trace_sched_switch.o
In file included from kernel/trace/trace_sched_switch.c:8:
include/linux/fs.h:1278: warning: function declaration isn’t a prototype
include/linux/fs.h:1282: warning: function declaration isn’t a prototype
  CC      kernel/trace/trace_functions.o
In file included from include/linux/debugfs.h:18,
                 from kernel/trace/trace_functions.c:13:
include/linux/fs.h:1278: warning: function declaration isn’t a prototype
include/linux/fs.h:1282: warning: function declaration isn’t a prototype


-- 
Slawa!
N.P.S.
