Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab0J2R7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:59:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48158 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934285Ab0J2R7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DLXI6iBaN35yxApyggHs23pSGCQpa7AVJBb05nD93l9nfqOxoYAP2j9ptFhMKvzhq9
         Cy8jfwgPp3s0YFevOqzm7Ur10ckQq6hpo+l4C+AgQAhr+RhhLl6cMG3PkCa40vuqtIvj
         b0IKDdA5/gCWQa1+hiNNX0WyNiVvQ92nSqMLM=
Subject: Re: percpucounter: Optimize __percpu_counter_add a bit through the
 use of this_cpu operations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1010291053440.21768@router.home>
References: <alpine.DEB.2.00.1010291053440.21768@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 19:58:56 +0200
Message-ID: <1288375136.2560.310.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 octobre 2010 à 10:56 -0500, Christoph Lameter a écrit :
> this_cpu_* operations can be used to optimize __percpu_counter_add a
> bit. Avoids some address arithmetic and saves 12 bytes.
> 
...
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



