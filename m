Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab0JAFEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:04:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34684 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab0JAFEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:04:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hqxK2Y9FNDT7VkO/PihAg7vt5VLiScAoZuvZj0F1ReSzIE5gxXpwkGl7QSUYt3Fb2K
         rkL+2WwsfErGqJWNh2QIsRL6yP5T8ktzAZA8t3jEoBja72dgtJFgIX6UjANxO68VM5+o
         +tYrNyKdukinFt7xweaVZVjV8XtKlve1NUeAk=
Subject: Re: [PATCH V3] fs: allow for more than 2^31 files
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Robin Holt <holt@sgi.com>
Cc: David Miller <davem@davemloft.net>, dipankar@in.ibm.com,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, den@openvz.org, mingo@elte.hu,
        mszeredi@suse.cz, cmm@us.ibm.com, npiggin@kernel.dk, xemul@openvz.org,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <20101001043413.GN14068@sgi.com>
References: <20100923121704.GR14064@sgi.com>
	 <1285246384.362.3.camel@edumazet-laptop> <20100923141037.GA3811@in.ibm.com>
	 <20100927.153639.212415479.davem@davemloft.net>
	 <1285645611.10438.27.camel@edumazet-laptop>
	 <20100930202612.GM14068@sgi.com> <1285879545.2705.4.camel@edumazet-laptop>
	 <20101001043413.GN14068@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 07:03:54 +0200
Message-ID: <1285909434.2705.35.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 23:34 -0500, Robin Holt a écrit :

> The proc_handler used to be proc_nr_files() which would call
> get_nr_files() and deposit the result in files_stat.nr_files then cascade
> to proc_dointvec() which would dump the 3 values.  Now it will dump the
> three values, but not update the middle (nr_files) value first.
> 

Ah I get it now, thanks !

I'll send a V4 shortly.



