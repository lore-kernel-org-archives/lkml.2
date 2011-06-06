Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab1FFUzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:55:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43989 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab1FFUzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n1qKRnTUTp5rd1A5QisAfqtk4MJfP7BkepdVEPncKGb+PhIlX291vJvWJYY5BHNCCM
         V5w6J7ITBPBTG5arlAC8ynY/B4h3uj9RWyG1Asevn9FolaY9v/dZeBXDFTiuyPicOj+8
         Xw/Op+OcgztWM5b8sLymQBj+QKoAmvRaABf14=
Subject: Re: [PATCH 1/3] atomic: use <linux/atomic.h>
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1307381251-15729-1-git-send-email-asharma@fb.com>
References: <1307381251-15729-1-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 22:55:46 +0200
Message-ID: <1307393746.2642.26.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 10:27 -0700, Arun Sharma a écrit :
> This allows us to remove duplicated code in <asm/atomic.h>
> More cleanup patches to follow.
> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: David Miller <davem@davemloft.net>
> Cc: Andrew Morton <akpm@osdl.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> LKML-Reference: <20110531105019.GF24172@elte.hu>
> ---

OK, you moved atomic_inc_not_zero() into include/linux/atomic.h without
telling so in Changelog.

Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks


