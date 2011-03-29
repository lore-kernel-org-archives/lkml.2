Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1C2G4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:56:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63983 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1C2G4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=QEZrcyjWnq8Fo/TwU+hT85MKEciXacbBnyFzYgfJR6troTB9bguRCv/yz898dJu+sD
         z5+TFERierF4e+/sOec4HQBwAaXQMYLU6NZfeWLl2LVKjq5LXJ0HXHrVWSVagpIopgy8
         E7yYFdtiU98ZxcDk10WqHO/QHHEBStEBP+Fgk=
MIME-Version: 1.0
In-Reply-To: <AANLkTimWq6RxWycZMugJDmQW3zXPfjHNQXqBbNyGPkvZ@mail.gmail.com>
References: <AANLkTimWq6RxWycZMugJDmQW3zXPfjHNQXqBbNyGPkvZ@mail.gmail.com>
Date: Tue, 29 Mar 2011 14:56:13 +0800
Message-ID: <AANLkTikQ7j6AOmY3zLjrttVUi0Y+KUTr0ASkhonuaY=g@mail.gmail.com>
Subject: Re: Why is there no debug symbols in my vmlinux?
From: Mr Shore <shore.cloud@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

I've configure all `CONFIG_DEBUG_` related options to `y`,but when I
try to debug the kernel,it says no debug symbols found:

    gdb /usr/src/linux-2.6.32.9/vmlinux /proc/kcore

    Reading symbols from /usr/src/linux-2.6.32.9/vmlinux...(no
debugging symbols found)...done.

And I've checked with `make V=1` that there is the -g flag.


Why, is this a known issue?

Thanks in advance!
