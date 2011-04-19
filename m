Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1DSCyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 22:54:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60642 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1DSCyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 22:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=bwr7YF7vkcbLOnUngGBgFvTiiSnJB2N6GsW5u1AtLqVk76okUgw1QBisxO3hrxO+iX
         LA0WQVavxvxvj7b8yDerAcG7YKLRwqw7F7F2QZevMMtY8ey7HlwG6UGwafcvMJGkqm3q
         pRAEC8F2aFaK0gq5ios2i8ZAcywqAkEmKJjDE=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 19 Apr 2011 10:53:46 +0800
Message-ID: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com>
Subject: [BUG] bluetooth doesn't work from 2.6.39-rc1+ to 2.6.39-rc3+
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cannot connect to any outside devices through bluetooth.

And I think this is not a bug of low level driver.  Because both my
laptop and a usb bluetooth card cannot work.

Thanks,
Hui
