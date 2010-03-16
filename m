Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937479Ab0CPHIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:08:11 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:48766 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937469Ab0CPHII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:08:08 -0400
Message-ID: <4B9F2E56.2060303@orcon.net.nz>
Date: Tue, 16 Mar 2010 20:08:06 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100121 Lightning/1.0b2pre Shredder/3.0.1
MIME-Version: 1.0
To: Will L Givens <wlgivens@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: Will's kernel compilation error
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com> <001e01cac4cc$98072ce0$c81586a0$@com>
In-Reply-To: <001e01cac4cc$98072ce0$c81586a0$@com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx3.orcon.net.nz on Tue, 16 Mar 2010 20:08:06 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Mar 16 20:08:07 2010
X-DSPAM-Confidence: 0.7617
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/10 18:50, Will L Givens wrote:
> It seems the problem, GPREL16, is pretty wide spread. I've tried building
> the drivers as modules, since that doesn't appear to be a problem *knock on
> wood* but one driver after another, after another, after another generates a
> new GPREL16 error! Raid0 drivers, numerous NetFilter modules, IR drivers
> (guess I can't use a Hauppauge card), and various other components. I'm
> going to try a few more configurations... then hit the sack. I'm pretty sure
> this is going to be a long process.

As has been suggested your best bet for help is to post your .config. 
If you don't want that publicly available then feel free to email it 
privately to Matt and myself.

FWIW, I have two Hauppauge cards (PVR350 card and a Nova-T-500 DVB-T 
card) in my Alpha, and have had no problems compiling the kernel, the 
ivtv modules, the DVB modules, and the IR modules.

If we cannot track down what you are doing differently than the rest of 
us, then there is little chance we can help you.

Cheers
Michael.
