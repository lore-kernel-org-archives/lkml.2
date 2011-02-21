Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1BUWQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:16:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55959 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1BUWQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:16:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=wGGRKuiXwpqWOxeKqUOr8mhu+lkjEmJyZOYVqxOQDKO7kAThRSeHS0H2hR0QCn7ayy
         8fO68yPeBQWTw81Mep7qhMasDbHwEsnSj4hFen64nN9tCRrWraFxOM1IvjgAqyNooVy2
         +3mEHqCoobtngoIcC/wvPavoq1kPKIHbQgiU8=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #29322] System lockup with 2.6.38-rc4+
Date: Mon, 21 Feb 2011 22:14:27 +0000
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <xmAo3o4v0VF.A.eLH.HWtYNB@chimera> <5HY1m9_-mkI.A.tTH.QWtYNB@chimera>
In-Reply-To: <5HY1m9_-mkI.A.tTH.QWtYNB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102212214.27880.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 February 2011, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the
> tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29322
> Subject		: System lockup with 2.6.38-rc4+
> Submitter	: Chris Clayton <chris2553@googlemail.com>
> Date		: 2011-02-14 17:31 (8 days old)
> Message-ID	: <201102141731.29331.chris2553@googlemail.com>
> References	: http://marc.info/?l=linux-kernel&m=129770471724602&w=2

Yes, I think this should stay open. I haven't heard anything since I replied to 
Ben Gamari on 14 February. having said that, I haven't experienced the lock up 
again since I reported it. Perhaps it's been fixed without me knowing.

Chris

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
