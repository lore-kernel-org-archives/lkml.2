Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0IFQmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 12:42:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34792 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0IFQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 12:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e4jeYk71bjmuILiGb39mf/KqmDgEFbkCJjF9oC1x65DrAkqMfAz3FN8Q2PPaNStLVa
         LTxrj8BEQ4Gug91wQc/rEOMjag7GqtQSvnk7nbvnjKzy5v+39v6TWiTP5LTSQXzOtue9
         Uv8qRbX/pRsAUUHPY3ONxM7QaF4MBsOd8c1jg=
Date: Mon, 6 Sep 2010 19:41:57 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: amba-pl010: fix set_ldisc
Message-ID: <20100906164157.GV25559@gw.healthdatacare.com>
References: <1283101965-12161-1-git-send-email-mika.westerberg@iki.fi> <20100904072323.GR25559@gw.healthdatacare.com> <20100904143812.GA13340@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100904143812.GA13340@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 07:38:12AM -0700, Greg KH wrote:
> 
> I've been acting as the def-facto serial maintainer, so I can take it.
> I'll queue it up in my tree, give me a few days till I get to it.

Great, thanks a lot.

Regards,
MW
