Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab0CVLPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:15:30 -0400
Received: from borg.asidev.net ([95.141.32.69]:52508 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab0CVLP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:15:29 -0400
Message-ID: <4BA7514D.3020901@evidence.eu.com>
Date: Mon, 22 Mar 2010 12:15:25 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ryan Mallon <ryan@bluewatersys.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Rick Bronson <rick@efn.org>,
       John Nicholls <john@thinlinx.com>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       michael trimarchi <michael@evidence.eu.com>, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] atmel_serial: Atmel RS485 support
References: <4BA335A8.1000205@evidence.eu.com> <4BA695E4.70105@bluewatersys.com>
In-Reply-To: <4BA695E4.70105@bluewatersys.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

    first of all, thank you for your feedback.

To me, all comments seem to be reasonable, except maybe the following one:

>>  
>> +static void atmel_start_rx(struct uart_port *port);
>> +static void atmel_stop_rx(struct uart_port *port);
> 
> Can you move these functions, so that these declarations are not needed?

Actually, atmel_stop_rx is already defined, and I prefer to not move it 
(since I change it, people may get confused by the diff...).
I also think that atmel_start_rx (which is added by the patch) should be 
near to atmel_stop_rx...



>> +        UART_PUT_IDR(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT |
>> port->read_status_mask);
> 
> This line, and a couple of others, extend over 80 characters. Could you
> please split them up.

Of course. I'm going to split them up and use a backslash at the end of 
  the original lines.


I will create a new patch according to your comments, test it and submit 
again to the mailing list.

Many thanks again,

                 Claudio



