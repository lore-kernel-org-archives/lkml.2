Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab0KQGBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:01:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40762 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab0KQGBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:01:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oojjin0D3ezFF4MR+Q7onajRwpJ6Fk/6OU7TyKlyn+8hpjDuB0XLUBb8eJZUyzYcXb
         Ims0X2f8qSom3x8WqObk2xbSA14Gc9cnGoHmEe1U/4Yd2F+P1ZhHiQQVYf4vb1l1lMY7
         d9Tnvf+tNWiOTCUC7ldhTp0jFEA8xJbsck/Ic=
Date: Wed, 17 Nov 2010 14:05:52 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, chatty@enac.fr,
        spbnick@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Drivers: hid: Makefile: Cleaned up Makefile
Message-ID: <20101117052123.GA5282@cr0.nay.redhat.com>
References: <1289141188-1447-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289141188-1447-1-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 09:46:27AM -0500, Tracey Dent wrote:
>Changed Makefile to use <modules>-y instead of <modules>-objs because -objs is
>deprecated and should now be switched. According to (documentation/kbuild/makefiles.txt).
>
>Signed-off-by: Tracey Dent <tdent48227@gmail.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
