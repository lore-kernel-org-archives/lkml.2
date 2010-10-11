Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0JKWzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:55:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61364 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab0JKWza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=VNDfOHQu0SrSEYcPh8EsJylqwcETT9mLqERZw5VwAsewW+JXpDlfhiWwm7jS3rFUbi
         Gbyk0F2yTg1v6vcT6gowNbX0FCXh/9gf2yRWw69xMOggRTIt/LSSnVww16Zs69V88c9t
         tgVJT0w2TeCcGV6iGw97ZgEdJstEo48E/hb7k=
From: Diego Calleja <diegocg@gmail.com>
Reply-To: diegocg@gmail.com
To: Cyrus Massoumi <cyrusm@gmx.net>
Subject: Re: Kernel Scalability to 48 cores
Date: Tue, 12 Oct 2010 00:55:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-dirty; KDE/4.5.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <4CB381DB.1040206@gmx.net>
In-Reply-To: <4CB381DB.1040206@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010120055.23602.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Lunes, 11 de Octubre de 2010 23:30:03 Cyrus Massoumi escribió:
> A friend just sent me the following PDF about Linux Scalability to many cores and I thought it might be interesting to the list for further discussion.
> It's about scalability problems of the Linux kernel and applications with 48 and more cores.
> 
> http://pdos.csail.mit.edu/papers/linux:osdi10.pdf

Some of the contention points mentioned in Figure 1 seem to be the same
things that Nick Piggin is trying to solve with his VFS scalability
patchset.
