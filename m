Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab1ANJFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:05:23 -0500
Received: from mail-wy0-f194.google.com ([74.125.82.194]:64560 "EHLO
	mail-wy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab1ANJFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:05:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QIULX9ZN53g4p1tQ6ljgijStK4tEHec1hTDrRvoBfi0hcd+Nr2UVRQX6LTvcFo5z0a
         oFhWLvm/1k2n2FgR35ZiJvgz4i3o4qwPXvySuhMQsOo3PKiL2H4TN+6b6llPMy2Cl+GM
         AJVtkzYt6jWce+eC14oFB4MdlvfHLGJAdaySM=
MIME-Version: 1.0
In-Reply-To: <20110114075104.GA7255@darkstar>
References: <20110114075104.GA7255@darkstar>
Date: Fri, 14 Jan 2011 20:05:14 +1100
Message-ID: <AANLkTi=zH=_8ARdbDceoGbNxP4BKv5z6ciwvBPnPF7TC@mail.gmail.com>
Subject: Re: [PATCH] staging: smbfs building fix
From: Nick Piggin <npiggin@gmail.com>
To: Yang Ruirui <ruirui.r.yang@tieto.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 6:51 PM, Yang Ruirui <ruirui.r.yang@tieto.com> wrote:
> Building error for smbfs:
>
> drivers/staging/smbfs/dir.c:286: error: static declaration of 'smbfs_dentry_operations' follows non-static declaration
> drivers/staging/smbfs/proto.h:42: error: previous declaration of 'smbfs_dentry_operations' was here
> drivers/staging/smbfs/dir.c:294: error: static declaration of 'smbfs_dentry_operations_case' follows non-static declaration
> drivers/staging/smbfs/proto.h:41: error: previous declaration of 'smbfs_dentry_operations_case' was here
> make[3]: *** [drivers/staging/smbfs/dir.o] Error 1
> make[2]: *** [drivers/staging/smbfs] Error 2
> make[1]: *** [drivers/staging] Error 2
> make[1]: *** Waiting for unfinished jobs....
>
> Fix it by removing static keywords

Thanks. It's a pain to find the options to compile the staging filesystems...
