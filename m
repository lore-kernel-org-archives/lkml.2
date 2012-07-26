Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab2GZRyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:54:09 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:33779
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147Ab2GZRyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:54:04 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q6QHrwSg023884
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Problem with commit cf03c5dac83609f09d9f0e9fa3c09d86daed614d
In-Reply-To: <20120726152121.GB10452@thinkpad-t410> (Seth Forshee's message of
	"Thu, 26 Jul 2012 10:21:21 -0500")
References: <gik3xqtzw3.fsf@karga.hank.lab>
	<20120726134926.GA10452@thinkpad-t410>
	<gi7gtqlfw2.fsf@mx10.gouders.net>
	<20120726152121.GB10452@thinkpad-t410>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Thu, 26 Jul 2012 19:53:57 +0200
Message-ID: <gizk6mjtmy.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 26 Jul 2012 19:53:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> On Thu, Jul 26, 2012 at 05:07:57PM +0200, Dirk Gouders wrote:
>> Hi Seth,
>> 
>> thanks for your reply and sorry for the noise.
>> 
>> I followed your advice and tried to boot with the WLAN interface turned
>> off, and the problem still exists.  I'll start a new bisect session,
>> probably with one of the commits you mentioned as the first good commit.
>
> Just to make sure three's not any confusion ...
>
> What I was suggesting was not just disabling the network interface but
> completely preventing brcmsmac from being loaded. The oops you saw
> happens in the context of the driver's probe function and would happen
> regardless of whether or not the interface is enabled.

Sorry for the confusion.

I already started a new bisect session, with a bad commit I disabled
brcmsmac in the kernel config and the problem still exists.  Now, I
continue with brcmsmac disabled and will see where the bisect ends.

Dirk
