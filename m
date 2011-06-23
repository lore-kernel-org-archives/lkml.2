Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab1FWSOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:14:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52819 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777Ab1FWSOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=aeysFW6eOAuVUE5II4ZlHh0APzDPLlZtuCeRFyfypa/wVOEsH5auQTekogDyn5vKg9
         maPMA4SRJWXN9f77JIAqxECHM4W7+VbzPrJvBPgjYzALQP+mj+aQqfL76CTMzx1Gmjoj
         HuOr/WQBq+VQpXRNsuOR7lkwFZL04TDGBGjUQ=
MIME-Version: 1.0
In-Reply-To: <20110623091429.2d51b0f0.randy.dunlap@oracle.com>
References: <20110623155431.6bfe3b40.sfr@canb.auug.org.au> <20110623091429.2d51b0f0.randy.dunlap@oracle.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 23 Jun 2011 14:13:38 -0400
Message-ID: <BANLkTinTZzjALrTEgofbFEG_pMSQw6uGWg@mail.gmail.com>
Subject: Re: linux-next: Tree for June 23 (net)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 12:14, Randy Dunlap wrote:
> On Thu, 23 Jun 2011 15:54:31 +1000 Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20110622:
>>
>> The powerpc allyesconfig (and probably others) is still broken because we
>> now build the staging drivers and because of a commit in the net tree.
>> The breakage in Linus' tree is fixed by one of Andrew's patches above.
>>
>> The net tree gained 2 build failures that I have left (see above).
>
>
> When CONFIG_INET is not enabled:
>
> net/core/dev.c:2535: error: implicit declaration of function 'ip_is_fragment'

i see this on two Blackfin defconfigs like CM-BF533
-mike
