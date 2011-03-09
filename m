Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1CITrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:47:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48717 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1CITru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:47:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RD5HcpvCvFavFWb8QZLaNgNO4iC4F6mt58IkXaAhVfss+iVdYuvfsnde86zy2/lLyj
         qdfNd/F8GzAuGoU6ob5k+9B0559L6E2oFE78oh/KivX1SLcaolrS40QF7GxPgpCRknTK
         JO/Wums4TKOMSeRJIbtEW5CANeB22qmuXjoa8=
Message-ID: <4D77D821.7090003@gmail.com>
Date: Wed, 09 Mar 2011 20:42:25 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v3][RESEND] Check for immutable/append flag in fallocate
 path
References: <4D6221B8.9040303@gmail.com>	<4D6F5473.2070709@gmail.com>	<4D720469.1010101@gmail.com> <AANLkTinyK0G=tfZob4u7XBj7Gna3FbZnLrqswz2oajwn@mail.gmail.com> <4D720C0B.1050300@gmail.com>
In-Reply-To: <4D720C0B.1050300@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/03/2011 11:10, Marco Stornelli ha scritto:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> In the fallocate path the kernel doesn't check for the immutable/append
> flag. It's possible to have a race condition in this scenario: an
> application open a file in read/write and it does something, meanwhile
> root set the immutable flag on the file, the application at that point
> can call fallocate with success. In addition, we don't allow to do any
> unreserve operation on an append only file but only the reserve one.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

Al, can you apply this patch please? I add Greg in cc, because maybe he
could be interested about stable tree.

Marco
