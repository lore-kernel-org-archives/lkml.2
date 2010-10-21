Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab0JUW7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:59:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47553 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab0JUW66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:58:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XQRv9yDAqLpy1M+t3HWORg74/dofAAHh/Qv+m1fQ3IW4lG5Plba+sX91mPpO+iTbTR
         AfQt92jzHxTmN/LU2LAfXiVNdjqKwIlktxMUWdaVn3eTN9PXNQEBDssIkgrTCqpRXM9O
         SzZZACMJt/cQ5mH/sloEeP2cJGRfVBNLFaDO8=
Subject: Re: [PATCH 16/17] fs: Convert nr_inodes to a per-cpu counter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101021153126.c1693e8e.akpm@linux-foundation.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-17-git-send-email-david@fromorbit.com>
	 <20100929215322.ff635d3e.akpm@linux-foundation.org>
	 <20100930061039.GX5665@dastard> <20101016075510.GH19147@amd>
	 <1287217748.2799.68.camel@edumazet-laptop>
	 <20101016020744.366bd9c6.akpm@linux-foundation.org>
	 <1287221475.2799.123.camel@edumazet-laptop>
	 <20101021153126.c1693e8e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 00:58:52 +0200
Message-ID: <1287701932.2607.34.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 21 octobre 2010 à 15:31 -0700, Andrew Morton a écrit :
> (working in time-reversed oreder again :()

> I don't know what "previous patch" you're referring to.

Nothing exciting, it was to update the comment that was slightly wrong
about size of percpu_counter...

(percpu_counter: change inaccurate comment)

https://patchwork.kernel.org/patch/238441/



