Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0H0Pz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:55:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62336 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0H0PzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:55:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=rRqCfPvdAW2u7Y+qzrCEZ7KuGMz4u4QGZKuJHyxfF7DDJrEKfZIqgGcfdCfYfnNucx
         11xWEUDrKFAVmnuOkF8V2vLk4Sb/QA2+i5CfQyTGbcoVOVSHNmrdE1oioEi05VLYUGUr
         zP/ey/M5EPuvV/C95Nh0a7iPmchkM9fdL2SrM=
From: Namhyung Kim <namhyung@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/43] ptrace: change signature of sys_ptrace() and friends
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
	<1282902149-12991-2-git-send-email-namhyung@gmail.com>
	<201008271521.35995.arnd@arndb.de>
Date: Sat, 28 Aug 2010 00:55:12 +0900
In-Reply-To: <201008271521.35995.arnd@arndb.de> (Arnd Bergmann's message of
	"Fri, 27 Aug 2010 15:21:35 +0200")
Message-ID: <87wrrcf3tr.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:
> Looks good to me. It may be worth mentioning in the changelog that
> 'unsigned long' is typically used in other places in the kernel
> as an opaque data type and that using this helps cleaning up a lot
> of warnings from sparse.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thank you. Will add it.

-- 
Regards,
Namhyung Kim
