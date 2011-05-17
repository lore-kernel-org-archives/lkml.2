Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab1EQStu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:49:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64013 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab1EQStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=U2lNx33BQ/Io0MQMfcp8eAaNbDnDTyeavQHB3rKB4un1fFdjnuy+DeyaJFjamwemfr
         4wrFjVEvCMmdgZnFWpegRxlTVAFwx6VkhnubRFW7cGEzNS+XwMuilgdOB1tZMDKFRyGC
         jruvv4B8Uc3IKpFTKgde6wANFI//U0p+MgmNQ=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: 2.6.38.6 -stable regression: kernel insta-death on boot.
Date: Tue, 17 May 2011 20:49:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc7; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Boris Ostrovsky <Boris.Ostrovsky@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <20110514195741.GA10757@elliptictech.com>
In-Reply-To: <20110514195741.GA10757@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105172049.44684.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 14 maja 2011 o 21:57:42 Nick Bowler wrote:
> 2.6.38.6 panics almost immediately on boot.  2.6.38.3 works fine.  Full
> kernel log and bisection results follow.  Reverting the implicated
> commit corrects the issue.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=35272
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
