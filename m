Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1A2MAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 07:00:06 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:55819 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1A2MAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 07:00:04 -0500
Message-ID: <4D44013B.8050306@ahsoftware.de>
Date: Sat, 29 Jan 2011 12:59:55 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?Um9nw6lyaW8gQnJpdG8=?= <rbrito@ime.usp.br>
CC: linux-kernel@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: [PATCH] ath3k: Avoid duplication of code
References: <20110127232453.GA3531@ime.usp.br> <4D4284D7.8000200@ahsoftware.de> <20110128221807.GA9741@ime.usp.br>
In-Reply-To: <20110128221807.GA9741@ime.usp.br>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.01.2011 23:18, schrieb Rogério Brito:

> Thanks for all the feedback on the previous patches. The one that
> didn't compile before was sent without a hunk. This time everything
> all the basics are verified.

They both had the same error, so I assume none of them compiled.

Besides that I don't have an opinion on your patch.

That stuff is only executed once when a device will be attached. The 
only reason I had a look at the code, was that I once got an out of 
memory error after I've attached such an device to a memory constrained 
(embedded) system.

Regards,

Alexander

