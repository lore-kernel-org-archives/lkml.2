Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1CQTI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:08:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41327 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1CQTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=S4upRmfkhkjVrIOg1trJSpforj85lUZyMutcaAZcGJ2reQjOO2ro9ao5kRxcbNaBAr
         h5WKk+FoOfPtyq+YEMom2UiL5//pmZE91AaQW2Usszl+PvwhZDb/Oa7kVEGjnTisG8Od
         /BUvIYqIt/ibOgO49dE2TMFKSLAGtTQ63LodU=
MIME-Version: 1.0
In-Reply-To: <20110317104434.GB22723@ZenIV.linux.org.uk>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
	<AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
	<20110317072344.GZ22723@ZenIV.linux.org.uk>
	<AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
	<20110317104434.GB22723@ZenIV.linux.org.uk>
Date: Thu, 17 Mar 2011 12:08:25 -0700
X-Google-Sender-Auth: J7RLnQoI7i86zTxCNQ6jMtbwjH4
Message-ID: <AANLkTi=rjVcEE8o-yDWma9G973kd4ikWLm+-cd3emwCO@mail.gmail.com>
Subject: Re: [git pull] mnt_devname queue
From: Tony Luck <tony.luck@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 3:44 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Mar 17, 2011 at 03:28:47PM +0800, Xiaotian Feng wrote:

Thanks for all the tips - I'll work on fixing (re-writing :-) pstore

-Tony
