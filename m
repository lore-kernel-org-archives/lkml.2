Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab0DEGGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 02:06:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61238 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab0DEGGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 02:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=upo+Y9FPW4u8kROQkaqUA9Q36C7TmWTeQf902f07NhwC7oSKvJ4d35qiqtRwuS1EHy
         NvkE9yhfAJDp5XrJFS7kxaKvX6k8zwk9WBQ44nDcPnby+vM5XqaiaQbIssgsfwweL2jv
         1JRhATkDsUSTrBb8GBkDFYx9yap7An14pBCPM=
MIME-Version: 1.0
From: Carl <carlchatfield@gmail.com>
Date: Mon, 5 Apr 2010 16:05:43 +1000
Message-ID: <x2pd56eedfb1004042305m3fdc4a8y7464a14e25cdb01c@mail.gmail.com>
Subject: Touchpad hacking, who to talk to before commencing work
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody, this is my first post to the list.

I have a new mbp 5, and I've been frustrated at the basicness of its
operation compared to its functionality under osx. My original plan
was to simply open
up the bcm5974 and create a deadzone at the bottom of the touch pad so
I could rest my thumb there and click. Configuration through synaptics
doesnt seem to work for some reason.

Anyway, to make a long story short, I had a bit too much fun with the
trackpad and watching it track all 10 fingers, and now I'd like to
implement some
more advanced functionality. As a quick hack, I could theoretically do
this inside the driver itself, but it would be better to write a new
input handler.

Is anyone currently working on something similar. I dont want to be
reinventing the wheel.

Cheers guys.

-- 
Carl
