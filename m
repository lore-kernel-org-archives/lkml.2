Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0KXPDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:03:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54977 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab0KXPDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wveJx2dCSsqAYQvSeJvIPVmHzSCatyRd3w/s6f6+nJXzy6WkMt3GL8aVGg0TzOuxi+
         wtro3j08ebcorgQSfZejMhPFkENQnNvbiu6fmnL9sftNJU7Sq2ZfH355H5PWVb2v1rS9
         SZDSbIkwOaD8W9vrAT5OWKnvmtg7juKTl4wn8=
Subject: Re: [PATCH] generic-ipi: add lock context annotations
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Carpenter <error27@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1290609214.2072.476.camel@laptop>
References: <1290411232-11439-1-git-send-email-namhyung@gmail.com>
	 <1290430003.2072.101.camel@laptop> <1290482390.1857.26.camel@leonhard>
	 <4CEB8034.80400@fusionio.com> <20101123094016.GC8882@bicker>
	 <1290576280.1690.13.camel@leonhard>  <20101124054305.GP1522@bicker>
	 <1290608996.1675.2.camel@leonhard>  <1290609214.2072.476.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 00:03:41 +0900
Message-ID: <1290611021.1675.26.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-24 (수), 15:33 +0100, Peter Zijlstra:
> Aside from complain, do these sparse annotations ever catch a bug?
> 

Dunno, sorry. I only have very limited experience of kernel development.

> I don't particularly like the __acquire() and __release() tags, but
> could possibly live with them when they only need to be in headers, but
> the __cond_lock() crap is just revolting.

Yes, it's very ugly. But some people told me it's a better way to
describe conditional lock acquisition from complicated functions. It
helped sparse recognize normal usage of such functions and suppress
warnings but only warn themselves.


-- 
Regards,
Namhyung Kim


