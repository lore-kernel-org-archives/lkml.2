Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1EFQH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:07:56 -0400
Received: from eriks.xs4all.nl ([83.160.41.216]:37804 "EHLO eriks.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1EFQHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=slagter.name; h=subject:from
	:to:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=2007072601; b=
	Qx7KM/NDh2Me98pYdGTpbzLiUlyDSoB2FEDLBSnxzxIg5lXLiey3kiqMbcizqq/C
	Ijslv4HlKTt50FsNEanVN45UU3cyRlgHgO957bZMVzaX+zJL4SvCp7/32J0S0XIJ
	Ykey+gE0KO0eY/GdWdWQES+b8Ehvu6UHR/uPw3rU8nQ=
Subject: Re: OOPS after connection Droids MuIn USB display
From: Erik Slagter <erik@slagter.name>
To: Maxin John <maxin.john@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTimcWN3=qvurDzyMUs8f5+uFPNumaw@mail.gmail.com>
References: <4DC3B0E3.7010008@slagter.name> <4DC3D296.9060707@slagter.name>
	 <BANLkTimcWN3=qvurDzyMUs8f5+uFPNumaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 18:07:47 +0200
Message-ID: <1304698067.4118.4.camel@poseidon>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have included some checks for "data_interface" since
> "usb_ifnum_to_if" could return NULL.
> Could you please check by applying this patch ?

In the meantime I've done a lot of bisection and inserting printk's
(needs a reboot every time, that's why I didn't react yet).

I think I can tell even a bit more than this patch will. I already found
out that the device appears to have no data connection but does have a
control connection. The lack of data connection seems to yield the NULL.
I will now test with data_connection forced to be equal to
control_connection, because apparently some devices actually work with
only connection, maybe this is one of them.

Will have more details later.

Thank you for your interest.

