Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab1ALVfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 16:35:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46823 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab1ALVfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:35:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=QTf9iYqalCVuZKYQIE0CFMtZsWdf93c1BHLucCF9cBEgycf/R8cqLDxwO2HceDS6ut
         SZHb8RQsFlcCWm3i1TeQ4vAxXtaVgEe/KNai7C9jlA8ZgnQWkroIlxNb+QRsT6C3pk5y
         n5fpS2scIEmQ1LwkaVgExK3BZWHRQAveTb2Iw=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 12 Jan 2011 13:35:29 -0800
Message-ID: <AANLkTinC=i24FaOtB3srbCUROza1V2TQ0zxNMq+QH+mj@mail.gmail.com>
Subject: Power plug off / on - EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I yank my power chord off of my Thinkpad T61 running 2.6.37 I get
the following:

[   79.523778] Monitor-Mwait will be used to enter C-3 state
[   81.195402] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600

mcgrof@tux ~ $ mount| grep sda1
/dev/sda1 on / type ext4 (rw,errors=remount-ro,commit=600)

When I plug the power chord it back in I get:

[  216.185265] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0

mcgrof@tux ~ $ mount | grep sda1
/dev/sda1 on / type ext4 (rw,errors=remount-ro,commit=0)

Is this to be expected?

  Luis
