Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0LIEUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 23:20:04 -0500
Received: from mail-qy0-f177.google.com ([209.85.216.177]:35645 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab0LIEUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 23:20:01 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Dec 2010 23:20:01 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JM59kL2mH3A6LWDNhehmORw6+qoJOeCt6mxkMPvBEWNEBQzB6AMMMCphQqVQEBccXS
         ObSWiZ3tMKRismTrh/awAAMeYRBxOGsKXsUYgQSmR7y81eY5aUHSyk/3Bd/NizESWFzy
         ZM/omnB480sWUd8OEJEhsuKlCqhRKzWRMArfM=
Date: Thu, 9 Dec 2010 12:13:10 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Sysctl interface to UNIX_INFLIGHT_TRIGGER_GC
Message-ID: <20101209041310.GA5101@cr0.nay.redhat.com>
References: <4D004E42.7000807@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D004E42.7000807@pavlinux.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 06:34:26AM +0300, Pavel Vasilyev wrote:
>Maybe something to add in Documentation/kernel-parameters.txt ?

No, that is for boot parameters, you need to find something like
Documentation/networking/ip-sysctl.txt.
