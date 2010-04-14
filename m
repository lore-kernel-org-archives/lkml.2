Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab0DNOiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:38:16 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:47032 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab0DNOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:38:14 -0400
Message-ID: <4BC5D34F.80304@lumino.de>
Date: Wed, 14 Apr 2010 16:38:07 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de>	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>	<4BBDC7D4.6040301@lumino.de>	<20100408143750.0acebaa1@lxorguk.ukuu.org.uk>	<4BC5B915.6090803@lumino.de> <20100414135704.3fc7b713@lxorguk.ukuu.org.uk>
In-Reply-To: <20100414135704.3fc7b713@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 02:57 PM, Alan Cox wrote:
> The important point is that you don't *have* to use futex to provide the
> posix pthread lock primitives if they don't fit your platform.
>   
I don't *have* to use Linux to provide the function the controller is
supposed to do for the end-user :).

But Linux is a very decent way to make it happen....

-Michael
