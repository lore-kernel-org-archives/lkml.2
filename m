Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2JUJxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 05:53:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42940 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2JUJxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 05:53:36 -0400
Message-ID: <5083C61C.5090807@gmail.com>
Date: Sun, 21 Oct 2012 11:53:32 +0200
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko@ursulin.net>
CC: dm-crypt@saout.de, linux-kernel@vger.kernel.org
Subject: Re: [dm-crypt] cryptsetup not working under 3.6 - regression from
 3.4?
References: <50830D33.5050807@ursulin.net>
In-Reply-To: <50830D33.5050807@ursulin.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2012 10:44 PM, Tvrtko Ursulin wrote:
> But I repeat, even if I load the required modules before hand things do 
> not work.

I would say you are still missing some modules.

> Kernel says this:
>   device-mapper: table: 252:1: crypt: Error allocating crypto tfm
>   device-mapper: ioctl: error adding target to table

It complains about aes-cbc-essiv:sha256.

It can be missing CBC od SHA256, but according the message I bet
you have no "cbc" block cipher mode module compiled.

Can you grep your final .config for CONFIG_CRYPTO_CBC and 
CONFIG_CRYPTO_SHA256 a paste it here?

Milan
