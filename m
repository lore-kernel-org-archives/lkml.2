Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1GSGqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:46:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57960 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1GSGqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <4E2525BA.4090902@gmail.com>
References: <4E252076.1050309@gmail.com>
	<CAD2nsn12vOXv-msWR+GF7edz3Q26P-pb4H-SO4rf2RHjC7mG+w@mail.gmail.com>
	<4E2525BA.4090902@gmail.com>
Date: Tue, 19 Jul 2011 12:16:00 +0530
Message-ID: <CAD2nsn3ifSMa_eFr2vQ0VVF9Ga-0VD3YB_beb28r+eoAHKv4kQ@mail.gmail.com>
Subject: Re: ath: Unable to reset channel (2412 MHz), reset status -5
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 12:05 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 07/18/2011 11:25 PM, Mohammed Shafi wrote:
>>
>> On Tue, Jul 19, 2011 at 11:43 AM, Justin P. Mattock
>> <justinmattock@gmail.com>  wrote:
>>>
>>> seems with the latest Mainline I am getting the ath9k carpping out after
>>> a
>>> while of streaming(dmesg below)..:
>>> http://fpaste.org/D7wM/
>>>
>>> will try a bisect if I have the time..
>>
>> I will try to recreate here with 3.0.0-rc7-wl, we can get more
>> information by ath9k debug=0xffffffff.
>> thanks.
>>
>
> cool!
> seems to fire off randomly over here.

I have got AR5416, will try with that.

-- 
shafi
