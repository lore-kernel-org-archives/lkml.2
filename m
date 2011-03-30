Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1C3KjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:39:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39479 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1C3KjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:39:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tid3pro4ZMfXLjadQKQPnbw3weybkywJR5fk0ZiB4HDy/gp+HxyEx2KlxR7mRMV5+5
         uNhYixUpkCfNReGS/ND+NsWnB7tjcDcXPc+ttRtPmXdU2FzI3imM6VatRvXTZ1tZCGgV
         Gse9yTYnHetjz5iJD41y5PT50FKgwvlqGzXO8=
MIME-Version: 1.0
Date: Wed, 30 Mar 2011 19:39:03 +0900
Message-ID: <AANLkTi=0h+wiU+Q0BXVtg_bFRch8vDgZ_Q7i7HBZkZD4@mail.gmail.com>
Subject: the latency difference between deadline and CFQ
From: NamJae Jeon <linkinjeon@gmail.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Jens.

I heard that deadline worked great from a latency in comparison with CFQ.

How do I demonstrate why the latency of deadlinne is better than CFQ ?

And would you inform me weakness of CFQ in comparison with deadline ?

Thanks.
