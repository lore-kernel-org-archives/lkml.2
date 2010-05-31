Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab0EaXji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:39:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48561 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0EaXjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cw3jEmaqKJR3hDDMZCjor9W4BB8R0JnsnOYi+uF9v2hh8avH4hWcOWQXgSBp1VXnmO
         73MA8AfD7hocxdf9qs9J76s4QBI1KwggegUysQafUAWJ0KeZ8GBst797FXvy3M+64X9z
         CGkqY4xzQvA7B0eYGe3TvoXcLjeSXzOEMTeIc=
Message-ID: <4C0448B5.7090904@gmail.com>
Date: Mon, 31 May 2010 17:39:33 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: alex.buell@munted.org.uk
CC: Mailing Lists - Kernel Developers <linux-kernel@vger.kernel.org>
Subject: Re: Article in Phoronix about loss of performance in 2.6.35 release
 candidates
References: <1275347969.29006.5.camel@lithium.local.net>
In-Reply-To: <1275347969.29006.5.camel@lithium.local.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 05:19 PM, Alex Buell wrote:
> http://www.phoronix.com/vr.php?view=14976
>
> Question: Why?

Good question.. I guess it would too much to ask of them to try to 
figure out what area the problem lies in (even to the point of figuring 
out if it's a CPU or IO-bound problem), or try to bisect, or at least 
report it to LKML before going to the trouble of creating 5 pages of 
graphs.. Given the 20x slowdown in some of the benchmarks you'd think it 
wouldn't be too hard to narrow down.
