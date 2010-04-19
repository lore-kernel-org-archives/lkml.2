Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0DSTc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:32:27 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:33112 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab0DSTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:32:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sw85LToGbmYA7GyhyOOECC10lzzLG65P54xmc6kFIh7qr1ukpnTC5IebujJx2wwEKB
         dZY31h73elv6x336jDkygSl4s81xfPYiorb27FgiY2CGQhg8cTTYZKkAN4z54xr/grRU
         HXTJXI8zKLjHEVfm9D4F/hoBWrclsQD3H9fVU=
MIME-Version: 1.0
Date: Mon, 19 Apr 2010 14:32:22 -0500
Message-ID: <k2se6bf505b1004191232l345ee0e6y260de901e0bfc4c9@mail.gmail.com>
Subject: Newer kernel with newer NPTL?
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I upgraded a 2.6.18-rt kernel to 2.6.33-rt and the my main
multi-thread application now consumes 12% cpu at idle, all threads are
a little bit busy while on 2.6.18-rt they are all quiet. I'm still
using glibc2.5/nptl. After spending a few days on
debugging/performance tuning the problem stays. Do I need upgrade
glibc/nptl to work with a newer kernel as far as performance is
concerned? This is a shipping product and we do not want to change
everything unless it's mandatory.

the WCHAN on 2.6.18 all showed "select" or "futex", on 2.6.33 it shows
"poll_schedule_timeout" or "futex_wait_queue_me" at idle, I wonder if
I need change 'select' in my application.

a bit off-topic here, thanks for any help.

xianghua
