Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab1BZPEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 10:04:31 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52422 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab1BZPE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 10:04:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=A95hYW+tYa+YxChrpgUZMwainqKr84l6i2OuirDkGYc/h1cUSP7GP5FmoCRFoPz9c9
         djfg84zjJNWBG8q2F3PlB+AI6OHe1bRRQJ2PYJymlTNnoZGcmucAyU4awKhrWhA1/3kc
         PoqO0jz0eVyHOn933Fu46uyCU2t58FPB73Ws8=
Message-ID: <4D69154F.8090000@gmail.com>
Date: Sat, 26 Feb 2011 15:59:27 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        cluster-devel@redhat.com, xfs@oss.sgi.com,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
References: <4D6221B8.9040303@gmail.com>
In-Reply-To: <4D6221B8.9040303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/02/2011 09:26, Marco Stornelli ha scritto:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> All fs must check for the immutable flag in their fallocate callback.
> It's possible to have a race condition in this scenario: an application
> open a file in read/write and it does something, meanwhile root set the
> immutable flag on the file, the application at that point can call
> fallocate with success. Only Ocfs2 check for the immutable flag at the
> moment.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

no comments?
