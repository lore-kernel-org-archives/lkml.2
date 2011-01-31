Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab1AaT3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:29:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64889 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab1AaT3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:29:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=UbBpRthowOazUFkOFf8cxNxaZY6q0QXm9P4QY4zEr1S/Lq8cta2eOajb6ZoiTH51ip
         FIzKx69ggXyFLJA4cntXOT3n4T07nJwLRcIfeLFxPy1YZjacPYy5sW++BYlzlDNmW4AU
         eAzS8izICE9ZUAwxCLpoqpX32NNiJomQw6m+o=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.38-rc2+ - regresiion copying DVD's
Date: Mon, 31 Jan 2011 19:29:05 +0000
User-Agent: KMail/1.9.10
Cc: simon@fire.lp0.eu, tj@kernel.org, kay.sievers@vrfy.org
References: <201101301550.59272.chris2553@googlemail.com>
In-Reply-To: <201101301550.59272.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101311929.05290.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 January 2011, Chris Clayton wrote:
> Hi,
>
> Firstly, I'm not subscribed, so please cc me on any reply.
>
> I'm trying to copy the3 contents of a video DVD from one disc to another,
> but it fails. There are no messages in the kernel log file, but K3B reports
> the following:
>
<snip>

Simon's patch at http://marc.info/?l=linux-kernel&m=129649842110692&w=4 fixes 
this problem, so feel free to add

Tested-by: Chris Clayton <chris2553@googlemail.com>

Thanks Simon

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
