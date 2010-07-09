Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0GIDv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:51:59 -0400
Received: from core.signal11.us ([64.251.29.136]:36558 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab0GIDv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:51:56 -0400
Message-ID: <4C369CDC.9080104@signal11.us>
Date: Thu, 08 Jul 2010 23:51:56 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David S Miller <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
       Michael Poole <mdpoole@troilus.org>, Bastien Nocera <hadess@hadess.net>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] Bluetooth: hidp: Add support for hidraw  HIDIOCGFEATURE  and HIDIOCSFEATURE
References: <1276467601-9066-1-git-send-email-alan@signal11.us> <1278623485.10421.73.camel@localhost.localdomain>
In-Reply-To: <1278623485.10421.73.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul  8 23:51:56 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c369cdc144131753669506
X-DSPAM-Factors: 27,
	Received*26+177, 0.01000,
	Subject*hidraw+HIDIOCGFEATURE, 0.01000,
	References*git, 0.01000,
	of, 0.01000,
	of, 0.01000,
	User-Agent*Mozilla/5.0, 0.01000,
	References*alan+signal11.us>, 0.01000,
	Received*ESMTP, 0.01000,
	Cc*<jkosina, 0.01000,
	Received*(c+76, 0.01000,
	Received*242.hsd1.fl.comcast.net+[76.26.177.242]), 0.01000,
	User-Agent*US+rv, 0.01000,
	Subject*HIDIOCSFEATURE, 0.01000,
	References*send+email, 0.01000,
	about, 0.01000,
	these, 0.01000,
	these, 0.01000,
	From*<alan, 0.01000,
	References*1+git, 0.01000,
	>+I, 0.01000,
	To*Holtmann, 0.01000,
	References*email+alan, 0.01000,
	User-Agent*U, 0.01000,
	To*<marcel, 0.01000,
	we, 0.01000,
	because, 0.01000,
	Cc*suse.cz>, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 05:11 PM, Marcel Holtmann wrote:
> I looked at this and I am bit worried that this should not be done in
> this detail in the HIDP driver. Essentially HIDP is a pure transport
> driver. It should not handle all these details. Can we make this a bit
> easier for the transport drivers to support such features?
>
> Regards
>
> Marcel
>    

Hi Marcel,

I put these changes (most notably the addition of hidp_get_raw_report()) 
in hidp because that's where the parallel function 
hidp_output_raw_report() was already located. I figured the input should 
go with the output. That said, if there's a better place for both of 
them (input and output) to go, let me know where you think it should be, 
and I'll get them moved into the proper spot.

I'm not sure what you mean about HIDP being a pure transport driver.

Alan.


