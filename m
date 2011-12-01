Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1LAPSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:18:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35485 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab1LAPSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:18:49 -0500
Message-ID: <4ED79AD5.2030700@gmail.com>
Date: Thu, 01 Dec 2011 07:18:45 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-pm@vger.kernel.org, rjw@sisk.pl
Subject: Re: suspend broken with macbookpro2,2 with the current Mainline
References: <4ED64AAC.5040405@gmail.com>
In-Reply-To: <4ED64AAC.5040405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 07:24 AM, Justin P. Mattock wrote:
> I seem to be hitting an issue with suspend on the current mainline.
> basically once I close the lid everything seems to work, even waking
> up(opening the lid), but if I close the lid and go to work I come back
> to my machine off(shutdown) after a few hours of being suspended.
>
> last good kernel I have is:
> 3.0.0-13-generic
> which is ubuntus generic kernel. I am in the process of starting a
> bisect but will take some time due to complete. if anybody is seeing
> this, and knows a fix let me know.
>
> Justin P. Mattock


apologise for the noise with this, seems my battery on the macbook has 
totally crapped out(no LED's nothing) causing the suspend to not be 
suspend for long periods of time a few days ago.

Justin P. Mattock
