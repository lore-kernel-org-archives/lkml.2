Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0HWPBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:01:10 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60112 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab0HWPBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=l7LnpxOSBajCBmAA6m34yzjJNmTkimA5QLNtit5t76Vd/EkaUFvbbeLsElvwnABhym
         Tb4NVNFbmb54Crft9Kr0G11Z+zcm1mGvnZ9G8C0L9Bdv8bV/csqOe41i7TVCwKjkhfg6
         HDgVdDmic5lCm80pdxV0PTUtn+QF0aRf5uDN4=
Subject: Re: [PATCH 2/2] workqueue: mark lock acquisition on
 worker_maybe_bind_and_lock()
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4C72423E.3000402@kernel.org>
References: <1282486783-4573-2-git-send-email-namhyung@gmail.com>
	 <4C72423E.3000402@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 00:01:01 +0900
Message-ID: <1282575661.1659.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-23 (월), 11:41 +0200, Tejun Heo:
> Also, please considering putting related patches into a thread.  For
> short series, just chaining them is good enough (ie. patch n+1 is
> reply to patch n).  For longer series, writing up a head message with
> overall description, diffstat and other general info about the patch
> series and making all patches reaplies to the head message is a good
> idea.
> 
> Thanks.
> 

OK. I see. Thank you for the advice.

-- 
Regards,
Namhyung Kim


