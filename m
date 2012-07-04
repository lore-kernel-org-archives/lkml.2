Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2GDStj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 14:49:39 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:60626 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272Ab2GDStH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 14:49:07 -0400
Message-ID: <4FF4901C.3010701@iki.fi>
Date: Wed, 04 Jul 2012 21:49:00 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dharam Kumar <dharam.kumar.gupta@gmail.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Info on Remote controller keys like upper-right, upper-left ,
 lower-right, lower-left ,sub-picture etc.
References: <CAOt5+pSrpsyvuyyT=kQj0k6u5m+KnJTH_+Q7hLhkkW0pNFSqpA@mail.gmail.com>
In-Reply-To: <CAOt5+pSrpsyvuyyT=kQj0k6u5m+KnJTH_+Q7hLhkkW0pNFSqpA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.190.162
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 09:34 PM, Dharam Kumar wrote:
> Hi All,
>
> I've been working on a MHL( www.mhltech.org  ) transmitter driver
> which needs to receive/handle incoming Remote control keys.
>
> The specification tells me that other than normal keys[up,down,left,
> right etc.] there are certain remote control keys like Upper-right,
> Upper-left, Lower-right, Lower-left, Sub-picture etc.
>
> While creating a key map in the driver, I tried to find whether these
> keys has been defined in <linux/input.h> ,but I could not find such
> key definitions
> in the header file.
>
> Please note that, although the Specs do define these Remote Controller
> keys, the driver will have the choice
> to support the key depending on the key-map.
>
> Something like this:
> /* Key Map for the driver */
>    ....
>   { KEY_UP, <supported> },
>   { KEY_DOWN, <supported>},
>   {KEY_UPPERRIGHT, <supported>},      /* No  definition for
> KEY_UPPERRIGHT in input.h  */
>   {KEY_UPPERLEFT, <not-supported>},  /* No definition for KEY_UPPERLEFT
> in input.h, although this key is not supported by driver */
> ....
>
>
> In other mailing lists[linux-input], it has been suggested that these
> keys are similar to Joystick keys.
> I've looked into drivers/input/joystick/analog.c file, but could not
> find any buttons/pads which are similar to the above one[Am I missing
> something here??]
>
> any pointers??

Here is list of key bindings used for media device remote controllers 
(television, radio, etc):
http://linuxtv.org/wiki/index.php/Remote_Controllers

But still no definitions like up-left etc.

regards
Antti


-- 
http://palosaari.fi/


