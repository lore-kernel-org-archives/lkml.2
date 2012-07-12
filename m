Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab2GLNXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:23:39 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:48723 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2GLNXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:23:37 -0400
Message-ID: <4FFECFC5.2080803@xs4all.nl>
Date: Thu, 12 Jul 2012 15:23:17 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Alan Stern <stern@rowland.harvard.edu>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.4.4: disabling irq
References: <Pine.LNX.4.44L0.1207111114460.1559-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1207111114460.1559-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-11 17:15, Alan Stern wrote:
> On Wed, 11 Jul 2012, Udo van den Heuvel wrote:
> 
>> New occurrence:
> 
>> Any clues and/or updates?
> 
> Didn't you see the message I posted on Monday?
> 
> 	http://marc.info/?l=linux-usb&m=134186054713868&w=2

Nothing changed except the kernel.
Main compononent on usb is the pwc webcam.
After the occurrence yesterday I unloaded motion and the pwc module.
But I got *another* occurrence round 20:47 hours.

How to list what modules/programs are using that irq?


Udo
