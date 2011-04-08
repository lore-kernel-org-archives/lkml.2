Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab1DHSRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:17:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34187 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab1DHSRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=xSfhvO3Uph8DMaxj6nwSd5HOpk8TD8cZTOLUOdF5igX1QiDKMQLSOJWeg2FJU/kVs0
         05jao/O0TmIPFNcpK8Kz9kU79RLeiJ7yAFJDcNh2PBlxMOb5v9QjBu2YGyqqvcbhhtDM
         TumNQD7A2w591+++NY54js8U9CwnwNHBpioT8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Alex Romosan <romosan@sycorax.lbl.gov>
Subject: Re: 2.6.39-rc1 doesn't boot on thinkpad t61p x86_64
Date: Fri, 8 Apr 2011 20:17:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <87k4fbnmw8.fsf@sycorax.lbl.gov>
In-Reply-To: <87k4fbnmw8.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104082017.07809.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=32902
for your bug report, please add your address to the CC list in there, thanks!

On niedziela, 3 kwietnia 2011 o 21:41:11 Alex Romosan wrote:
> nothing happens, i just get a blank screen right after loading
> 2.6.39-rc1, no disk activity, nothing. this is still happening with
> 2.6.39-rc1-git3. i tried to do a git bisect but after a lot of compile
> failures and getting strange kernel versions like 2.6.37+ (i never
> understood this. if i say git bisect bad for the head and git bisect good
> v2.6.38 shouldn't i just get the commits between those two versions?) i
> gave up. anyway, i did a binary search through the git versions between
> 2.6.38 and 2.6.39-rc1 and found out that the last version to boot for me
> was 2.6.38-git14. how can i bisect the commits between git14 and git15?
> anyway, i'm attaching my .config file. maybe somebody has an idea of
> what went wrong.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
