Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab0LIUG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:06:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53170 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab0LIUG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:06:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Vl89kaXpcGEQ8DG1iPvT8ToFr5UbECkFiVGHy5YbudW4ISUbzcu6cniA9Z6i5qZSvW
         V1O23nJe8i9lcOdiaAb1TLJk8byhqGFb6Paw8s1btkzfUtbG6l3eOMbWtVqUY8SIWVlU
         hSD1fqNJNC+KKIKTT89SgPWaI3j3AUGePDs7U=
MIME-Version: 1.0
In-Reply-To: <29ab1782961e5d9b56972818f12eb7a2e5bd4329.1291923889.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com> <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
 <29ab1782961e5d9b56972818f12eb7a2e5bd4329.1291923889.git.joe@perches.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 9 Dec 2010 15:06:34 -0500
Message-ID: <AANLkTikUTdCRZP9FR1-16MmH4zysKha7m2o_DH6As-HJ@mail.gmail.com>
Subject: Re: [PATCH 03/15] rtc: Remove duplicate unlikely from IS_ERR
To: Joe Perches <joe@perches.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jiri Kosina <trivial@kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 15:03, Joe Perches wrote:
> IS_ERR already uses unlikely, remove unlikely from the call sites.

Tobias already submitted a patch for this.  and i cc-ed you on it.
-mike
