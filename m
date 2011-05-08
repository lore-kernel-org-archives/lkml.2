Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab1EHU3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 16:29:08 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:40043 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750753Ab1EHU3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 16:29:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cgnvtKOG0BQ8OL5i1WYK16c3yYq4cksua3dfINvnR38niJ5bzjS7TRK0YcA7xJxBNUvIvgttWgj3+oYzzNRAHTJymjxB/V0flH/xu4Ah1pptN/WUoYHWkOOIEv6JvYa1;
Date: Sun, 8 May 2011 13:29:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any objection to my updating Doc/driver-model/bus.txt?
Message-Id: <20110508132902.63f96952.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.00.1105081430380.3288@localhost6.localdomain6>
References: <alpine.DEB.2.00.1105081430380.3288@localhost6.localdomain6>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 May 2011 14:31:37 -0400 (EDT) Robert P. J. Day wrote:

> 
>   that particular documentation file is clearly out of date.  i can
> take a shot at bringing it up to date unless someone is already
> working on that.

First look at patches posted on linux-doc mailing list:

http://marc.info/?l=linux-doc&m=130455335625331&w=2
http://marc.info/?l=linux-doc&m=130455337025346&w=2
http://marc.info/?l=linux-doc&m=130455338425367&w=2

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
