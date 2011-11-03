Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab1KCQi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:38:56 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34976 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933891Ab1KCQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:38:54 -0400
Date: Thu, 3 Nov 2011 17:38:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: Lars =?ISO-8859-1?B?Tm9vZOlu?= <lars.nooden@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Hardware running hot and without the fan
Message-ID: <20111103173841.367d4081@endymion.delvare>
In-Reply-To: <1320332801.2309.60.camel@groeck-laptop>
References: <4EB1108F.6070009@gmail.com>
	<20111103020301.GA22333@ericsson.com>
	<4EB250FD.3070000@gmail.com>
	<20111103134902.GA26121@ericsson.com>
	<4EB2A46B.8080600@gmail.com>
	<1320332801.2309.60.camel@groeck-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011 08:06:41 -0700, Guenter Roeck wrote:
> You should be able to set the fan speed by writing into the fanX_input
> and/or fanX_output sysfs attributes. You find those
> in /sys/class/hwmon/hwmon0/device (assuming there is only one hwmon
> device).

Note that fanX_input is always a read-only file, so writing to it isn't
going to do anything.

fanX_output is not a standard attribute for hwmon devices, it shouldn't
be there in the first place... The applesmc driver doesn't see to
follow the standard interface, so it's probably best to not assume too
much.

-- 
Jean Delvare
