Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2EHSuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:50:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59606 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab2EHSuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:50:50 -0400
Message-ID: <4FA96AEF.4090106@zytor.com>
Date: Tue, 08 May 2012 11:50:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Chase Douglas <chasedouglas@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, chatty@enac.fr,
        benjamin.tissoires@gmail.com, peter.hutterer@who-t.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Input: MT - Include win8 support
References: <1336230499-1450-1-git-send-email-rydberg@euromail.se> <4FA5889E.2030008@gmail.com>
In-Reply-To: <4FA5889E.2030008@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 01:07 PM, Chase Douglas wrote:
>>  
>> +For devices capable of 360 degree orientation, the reported orientation
>> +should be twice the given range.
> 
> I don't understand what this means. Can you elaborate?
> 

A guess is that it means that the value is encoded as a single byte with
a 2° granuarity?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

