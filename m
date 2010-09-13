Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0IMT4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:56:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48365 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab0IMT4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jkAWuqqWvHgxCREo7UmioFFqMj96eNvCip6cJdVHqI9yJAXnK8jETLpyg+GOUFouAe
         yM9PaRWAjuY7tgUmVOE7ARUbbVBSpVHzsYT7QKeTea4+IW03EhscfGq8D3nc4EqF4q29
         nhzAC6K0hFx1DrQZbW8JKfxLkNnMq7W+7ImU4=
Message-ID: <4C8E8227.3050507@gmail.com>
Date: Mon, 13 Sep 2010 12:57:27 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]scripts/kconfig/gconf.glade Update broken web addresses.
References: <1284184584-8647-1-git-send-email-justinmattock@gmail.com> <4C8E49C8.6090003@suse.cz>
In-Reply-To: <4C8E49C8.6090003@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This URL does not host the dtd itself, so we can as well remove the
> DOCTYPE declaration alltogether. I guess libglade validates the file
> against it's own schema anyway.
>
> Michal
>


o.k. hopefully it's as easy as just removing the whole DOCTYPE line
(if there's more to this, im not real sure on what todo..)

Justin P. Mattock
