Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0KMGHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 01:07:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42729 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0KMGHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 01:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WoE1vFcen+Bj0Fpxbo3Y9CwlTcYUpp5Cyave+WZWuHhcpS810vY1O1sHKF1ZqnseTV
         w+uxo3hB92QQtmZcqwGg2aP7aJ7GJbIWFs6YAPdsTE0qTBNgz8ZErYvSyiAK8RKssKIS
         if9pbWtx6jY+ldYcb9hSequxK4yueMK8Ejsdg=
Message-ID: <4CDE2B33.9050404@garzik.org>
Date: Sat, 13 Nov 2010 01:07:47 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com> <20101113042821.GE18258@parisc-linux.org> <AANLkTik_eXv1_ZaqD01CoT6igzjBZtmECD0e+QUkMhxP@mail.gmail.com> <1289628103.3015.608.camel@mulgrave.site>
In-Reply-To: <1289628103.3015.608.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 01:01 AM, James Bottomley wrote:
> I'd like to get rid of done too.  I'm ambivalent on whether we pass in
> the host or not, but I did it anyway.
>
> The patch is reasonably small but there are a few driver prototypes to
> clean up as well.  How does the attached look? If OK, I'll fold it in
> and resubmit the pull.
>
> I think I picked up all the non-x86 drivers that don't show up under
> allmodconfig, but it would be nice to incubate this in next for another
> couple of days to be sure.

Looks like you caught the megaraid deadlock, but missed a few others... 
  I'll rediff mine as incremental as discussed on IRC.

