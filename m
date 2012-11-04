Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2KDLeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 06:34:11 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:38037 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2KDLeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 06:34:08 -0500
X-Greylist: delayed 3747 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Nov 2012 06:34:08 EST
Message-ID: <509643EF.2060902@xs4all.nl>
Date: Sun, 04 Nov 2012 11:31:11 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.4.4: disabling irq
References: <Pine.LNX.4.44L0.1207151423440.29236-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1207151423440.29236-100000@netrider.rowland.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well,

The issue appeared again.
irq 18 was disabled, one pwc webcam was on that irq.

This time on new hardware: Gigabyte F2A85X-UP4 with A10-5800K APU.
The box was busy with it's raid10 array, this time, by running bonnie++;
also a raid-check was in progress. (unknown at the time)

So what does this say? It appears not to be a hardware problem per se.

Anyone?

Kind regards,
Udo


