Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1JCFLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:11:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38326 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab1JCFLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:11:46 -0400
Message-ID: <4E89440E.8060702@lwfinger.net>
Date: Mon, 03 Oct 2011 00:11:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110922 Thunderbird/7.0
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, git@vger.kernel.org
Subject: Re: unable to resolve reference refs/tags/v3.1-rc8: Success
References: <4E892483.7070605@lwfinger.net> <20111003035907.GA17134@elie> <4E8936F4.5060506@lwfinger.net> <20111003044045.GA17289@elie>
In-Reply-To: <20111003044045.GA17289@elie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2011 11:40 PM, Jonathan Nieder wrote:
> Larry Finger wrote:
>
>> After applying that patch, I get
>>
>> finger@larrylap:~/linux-2.6>  ~/git/git pull
>> fatal: ref refs/tags/v3.1-rc8 is corrupt: length=41, content=
>
> Great, thanks.
>
> In the short term I'd suggest just removing the corrupt
> .git/refs/tags/v3.1-rc8 file with "rm" so it can be fetched again.
> Hopefully later tonight I can prepare a real patch to fix this, though
> I wouldn't mind if someone else takes care of it first.

Thanks. That did the trick.

Larry

