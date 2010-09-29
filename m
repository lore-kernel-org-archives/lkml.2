Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0I2UFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:05:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46713 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab0I2UFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=Llm1u3LpRvHJeBfHpfHB47OZEGReZ0WuiB3pQbnBWlrSUIG4kKTFTeuRQdBxlXgXZw
         FiCB1z5lOhdjeyuFIHfIDmOWOyKZNo1X4LsYik3uBpoiecN0Sx2+UzHAwvHEct8Fr680
         9znpfFopcZFWK4/6VXxXuHkerHqOjOcIgy2jg=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 29 Sep 2010 13:05:30 -0700
Message-ID: <AANLkTim=dHyuS=WP0LY6eZUr71J4kLqEtkrsM5fPS6C+@mail.gmail.com>
Subject: [ANN] Atheros Linux Bluetooth drivers home page
To: linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Ken Steck <Ken.Steck@atheros.com>,
        Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noted a while ago Bluetooth seemed to lack a wiki-based home and if
we can just borrow the existing wiki on wireless.kernel.org and saw no
opposition so started adding some related Bluetooth documentation like
Bluetooth-Coexistance [1]. I now found a need to document some pending
patches for ath3k [2] so started a Linux Atheros Bluetooth drivers
page [3] with just one reference to ath3k [4]. Goal is also to
motivate and welcome more developers to document more of the Bluetooth
subsystem and drivers on wireless.kernel.org. If you have a Bluetooth
drivers you'd like to document please feel free to add it to the
Bluetooth Drivers section [5] BT3.0 stuff might be a really good
candidate to be documented here. I tried modifying the site a bit to
add Bluetooth Specific navigation bar but failed, will wait on
Johannes to figure that stuff out.

  Luis

[1] http://wireless.kernel.org/en/users/Documentation/Bluetooth-coexistence
[2] http://marc.info/?l=linux-bluetooth&m=128536965702436&w=2
[3] http://wireless.kernel.org/en/users/Drivers/Atheros-BT
[4] http://wireless.kernel.org/en/users/Drivers/ath3k
[5] http://wireless.kernel.org/en/users/Drivers-bluetooth
