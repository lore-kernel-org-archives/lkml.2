Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab0FUN6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:58:38 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:59816 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab0FUN6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=uhXwrQHhB0VyhgRuUCc/HbGJKCZpuCX6YZWg2OrSCdUelXZyvtmH3pX93N/v3CtZ7e
         l38fi8eMv/aUKLgIwkWfwuhx88mAKXpAdLaV5edkHrVYCbPMg5iLX4WCKWbyJHkDY4kr
         JVVCC/vLDuJXfAw273P1eulHy3qrFz+YFMIZo=
MIME-Version: 1.0
From: Weedy <weedy2887@gmail.com>
Date: Mon, 21 Jun 2010 09:58:16 -0400
Message-ID: <AANLkTil7mInflmvrvVQmOx7xrNVFAY7GtqQiGobHMTT2@mail.gmail.com>
Subject: Entropy poolsize
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know grsecurity has a option for this but I don't want to patch my
kernel with it at this time. I have been poking around random.c but I
can't seem to figure out where .poolsize is assigned it's value and
how to increase it.

If someone could point it out that would be nice.

Thank you for your time.
