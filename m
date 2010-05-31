Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab0EaXjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:39:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62664 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab0EaXjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=EqbtIIKWaxfkiwTibo8hLsOGBh9/xIwIC0st80chEfzKS9czkpJRm8vlQHTRMxv4YV
         IW61uhXA+0f+WPV2uc4YcCvNqUdVQb4HXSkon9S9wsw7w6jzXKKLeGDpIgXa3fl4QrMB
         sg3yhPioSkwL9ENmDH10QXJHrYsWfzhmv8nLo=
MIME-Version: 1.0
Date: Tue, 1 Jun 2010 01:39:43 +0200
Message-ID: <AANLkTimEFy6VM3InWlqhVooQjKGSD3yBxlgeRbQC2r1L@mail.gmail.com>
Subject: Possible bug in 2.6.34 slub
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I've recently noticed this line on the dmesg output(kernel 2.6.34):
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=16, Nodes=1

My cpu is an I7 920, so it has 4 cores and there's hyperthreading
enabled, so there are 8 logical cpus. Is this a bug?

-- 
Giangiacomo
