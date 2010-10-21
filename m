Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab0JUXWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:22:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59158 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab0JUXWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w3GM4jqRNw83q1AzDO7RQGEP1Ib1C0YmduaBpIt5SgMrMy4EsjgMfRIdDHrMwTTfq0
         fDAMVPw4MaqdVXKDtrawPbHIzNaqcjVue8w9c5NwPdP6NyxEdza+0Funyr+sRrOqR/k5
         jSylXv5cDerwAYWSi/19C+e80J0QGRK9JxyfM=
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20101021161801.8149e2fe.akpm@linux-foundation.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-17-git-send-email-david@fromorbit.com>
	 <20100929215322.ff635d3e.akpm@linux-foundation.org>
	 <20100930061039.GX5665@dastard> <20101016075510.GH19147@amd>
	 <1287217748.2799.68.camel@edumazet-laptop>
	 <20101016020744.366bd9c6.akpm@linux-foundation.org>
	 <1287221475.2799.123.camel@edumazet-laptop>
	 <1287238754.2799.376.camel@edumazet-laptop>
	 <20101021154333.f67fd870.akpm@linux-foundation.org>
	 <1287701894.2607.32.camel@edumazet-laptop>
	 <20101021161801.8149e2fe.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 01:22:03 +0200
Message-ID: <1287703323.2607.39.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 21 octobre 2010 à 16:18 -0700, Andrew Morton a écrit :
> On Fri, 22 Oct 2010 00:58:14 +0200
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Then 39 instructions in hot path (no lock taken)
> 
> Wow, your compiler sucks.
> 


Actually my machines are mostly 32bit. Is it a problem ?

Compiler is OK, really.

percpu_counter() is misnamed, it should be named percpu_counter64() or
something like that :-(



