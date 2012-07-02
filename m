Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2GBGJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 02:09:04 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:37036 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab2GBGJB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 02:09:01 -0400
From: Preetham-rao K <preetham.rao@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 2 Jul 2012 08:08:41 +0200
Subject: RE: [PATCH] remoteproc: block premature rproc booting
Thread-Topic: [PATCH] remoteproc: block premature rproc booting
Thread-Index: Ac1WB2GKmv30uUvDRY+rYfJZ18bEYACEZJ+Q
Message-ID: <81C3A93C17462B4BBD7E272753C10579232F86B9A7@EXDCVYMBSTM005.EQ1STM.local>
References: <81C3A93C17462B4BBD7E272753C10579232F86B623@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbYXR7ino3LN1UKbmHi=qhYgQbF439mD93rVXFWTf68osw@mail.gmail.com>
In-Reply-To: <CAK=WgbYXR7ino3LN1UKbmHi=qhYgQbF439mD93rVXFWTf68osw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

Thanks for your reply.

Hi Fernando,

Can you kindly share the patches?

Regards,
Preetham rao

-----Original Message-----
From: Ohad Ben-Cohen [mailto:ohad@wizery.com] 
Sent: Friday, June 29, 2012 8:26 PM
To: Preetham-rao K
Cc: Fernando Guzman Lugo; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remoteproc: block premature rproc booting

Hello Preetham rao,

On Fri, Jun 29, 2012 at 2:13 PM, Preetham-rao K
<preetham.rao@stericsson.com> wrote:
> We have some questions .
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
