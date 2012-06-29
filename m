Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2F2O4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:56:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56366 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab2F2O4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:56:30 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.43.174]
In-Reply-To: <81C3A93C17462B4BBD7E272753C10579232F86B623@EXDCVYMBSTM005.EQ1STM.local>
References: <81C3A93C17462B4BBD7E272753C10579232F86B623@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 29 Jun 2012 17:56:09 +0300
Message-ID: <CAK=WgbYXR7ino3LN1UKbmHi=qhYgQbF439mD93rVXFWTf68osw@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: block premature rproc booting
To: Preetham-rao K <preetham.rao@stericsson.com>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Preetham rao,

On Fri, Jun 29, 2012 at 2:13 PM, Preetham-rao K
<preetham.rao@stericsson.com> wrote:
> We have some questions …
>
>
>
> Is remoteproc  self governor  the remote processor?
>
> When the time of crash on remote processor, will remoteproc take care of
> loading the firmware?

Yes. the low level driver just has to notify remoteproc that the crash
occurred, and the remoteproc framework will take care of the rest.

This is not upstream yet - but Fernando (cc'ed) already has the
patches and can probably share them with you if you're interested.

Ohad.

> Or user has to drive this using remoteproc API?
>
>
>
> Regards,
>
> Preetham rao
