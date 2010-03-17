Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0CQKgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:36:13 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:41066 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0CQKgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=a0leZoR/FD3NY0Vj5udPY57UNOmOJz0rWXVMZz/UUkeZOsfwImohiD0CbmxTC73Yjh
         uAG/X6nNCjrB2rlp25ipf9TDEIEBcL3qihxhb/FuXc2JfAgAQ2J55RgatEs9cF/1/l4J
         2+HZsOZlH/GC4MFFakwOac5S3gIOx5iJ3AG5I=
MIME-Version: 1.0
Date: Wed, 17 Mar 2010 20:36:10 +1000
Message-ID: <5b421c151003170336g36190604jd94c0f5713fca77a@mail.gmail.com>
Subject: ALPS Touchpad driver
From: Mark Eaton <eaton.mark@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I have a laptop (HP mini 311) which has an ALPS touchpad that isn't
recognised by the ALPS driver. I've been trying to update the driver to
make it work, and whilst I can make it recognise the device, the device
doesn't seem to respond to the ps2 commands in the same way as the other
supported touchpads do.

I have so far been unsuccessful in finding any documentation for ANY
of these devices, so if it does exist could someone point me to where
it lives.

If there is no documentation which is I suspect the case, could anyone
provide any pointers on how I could attempt to figure out how to get
this device to work.

Please cc me in any replies as I am not subscribed to the list.

Thanks

-- 
Mark Eaton
Brisbane, Australia
