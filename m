Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1C1HP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:15:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43321 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1C1HP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=Y/9rOr93d4RezyY12FoaFkA63MgIFd5Uuwt2ELw9pSRYdAjv6bhGrC8sOSY9IjWMSt
         CgUVCH0LiXuz6HnjOigNmHcCZboKkfVN21pbNm9qGdap9n04ztCI550juoosVF2GQGTH
         sTlzTpEURZ5hM15PnPTlqTHdqrhmYq1kb8rtE=
MIME-Version: 1.0
In-Reply-To: <1301296053-23589-1-git-send-email-amwang@redhat.com>
References: <4D90206E.1090307@redhat.com> <1301296053-23589-1-git-send-email-amwang@redhat.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 28 Mar 2011 03:15:07 -0400
X-Google-Sender-Auth: Kg4eemkcZy8rz2WVuFrV7-zpaYs
Message-ID: <AANLkTim12OG_fB5vTL47jtyqdfBr61hO_=wUeyR2BG=0@mail.gmail.com>
Subject: Re: [PATCH 1/2] proc: Use IS_ERR_OR_NULL() helper
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric B Munson <emunson@mgebm.net>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        David Howells <dhowells@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 3:07 AM, Amerigo Wang wrote:
> Use IS_ERR_OR_NULL() helper

copying & pasting the summary as the only changelog is kind of useless

as for the patch, looks pretty straight forward to me
-mike
