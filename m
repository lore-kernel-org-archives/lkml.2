Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab0KXFnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:43:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43240 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0KXFnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:43:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=CN2RsEgD2xjPhZAjlKT22WLGEl44mf+IxvZcNIdzO+s1qzzOeWe8JHzc2u6rkT6c7r
         LBA6LXDpcOgAyt5zUleEYy7ov8gO4cZ26Y+l/8lk3NE2Wz425N5XDuFxAWxY/Q9EQ7aU
         iE+aTM14a7w5sZjTlOzYw7pp5ugBBNjpK8gKc=
Date: Wed, 24 Nov 2010 08:43:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] generic-ipi: add lock context annotations
Message-ID: <20101124054305.GP1522@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Namhyung Kim <namhyung@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1290411232-11439-1-git-send-email-namhyung@gmail.com>
 <1290430003.2072.101.camel@laptop>
 <1290482390.1857.26.camel@leonhard>
 <4CEB8034.80400@fusionio.com>
 <20101123094016.GC8882@bicker>
 <1290576280.1690.13.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290576280.1690.13.camel@leonhard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 02:24:40PM +0900, Namhyung Kim wrote:
> 2010-11-23 (화), 12:40 +0300, Dan Carpenter: 
> > On Tue, Nov 23, 2010 at 09:49:56AM +0100, Jens Axboe wrote:
> 
> I tried to annotate declations in include/linux/smp.h but it didn't work
> well. Maybe that's what we need to fix the sparse?
> 

It worked for me earlier when I tested it.  Just add the exact same
annotations that you added to the .c file.

regards,
dan carpenter

