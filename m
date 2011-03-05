Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1CERLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:11:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48324 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1CERLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=aFEsCejbVCndtmhUAbGCNBJtSZRNUVvUjniAdYF9mx6E/9r4Bb57tdwB7xu/9xPNMN
         Wg3Bn5/3YNw+eNQsGGjsiKsckkSWOZl+q0sGWca5um0obPwwB2QRhdFTRqGZF0WjVn3B
         mEKJWmGkdXttTklAfmcEnck59neoVDtD3Zmis=
MIME-Version: 1.0
Date: Sat, 5 Mar 2011 18:11:20 +0100
Message-ID: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
Subject: brcm80211: the system freezes if booted with laptop wifi switch to OFF
From: Francis Moreau <francis.moro@gmail.com>
To: brudley@broadcom.com
Cc: gregkh@suse.de, linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently running 2.6.38-rc6, and if I boot with my WIFI switch
set to off position, the system freezes entirely when bringing up the
wlan0 interface.

There's no trace so I don't really know how I can help to debug this further.

Thanks
-- 
Francis
