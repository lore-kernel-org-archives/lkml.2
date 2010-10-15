Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0JOFoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 01:44:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49327 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab0JOFoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 01:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=camiJ0O/cNHQXIEbc9bI9gXlARFI6Ozy3jfwtFGtHPNPEqKkjNjwndkrpwuuH5W4jU
         mEdFmu00v75ROcQYtmZnJTO/3d3yKGWfDJC3L9jMdv6f82TAYASzYcA3wlbO/bjV7L9E
         KV6Pahh83UmmgDHXaSqFTTUqO+IyQHL3WpXoI=
MIME-Version: 1.0
In-Reply-To: <1287120477.20429.3.camel@mola>
References: <1287120381.20429.1.camel@mola> <1287120477.20429.3.camel@mola>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 15 Oct 2010 01:43:47 -0400
X-Google-Sender-Auth: ht9tQ9bqLM7uyjUpgGNRWOJ6g5s
Message-ID: <AANLkTinNAjfzhGcyGbUtWhJOydJM-P7S8yZGTeTvVi6x@mail.gmail.com>
Subject: Re: [PATCH 2/3] USB: isp1362-hcd - use resource_size instead of
 defining its own resource_len macro
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Lothar Wassmann <LW@karo-electronics.de>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
