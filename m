Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2GBVK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:10:59 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:54298 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118Ab2GBVK6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:10:58 -0400
MIME-Version: 1.0
In-Reply-To: <81C3A93C17462B4BBD7E272753C10579232F86B9A7@EXDCVYMBSTM005.EQ1STM.local>
References: <81C3A93C17462B4BBD7E272753C10579232F86B623@EXDCVYMBSTM005.EQ1STM.local>
	<CAK=WgbYXR7ino3LN1UKbmHi=qhYgQbF439mD93rVXFWTf68osw@mail.gmail.com>
	<81C3A93C17462B4BBD7E272753C10579232F86B9A7@EXDCVYMBSTM005.EQ1STM.local>
Date: Mon, 2 Jul 2012 16:10:51 -0500
Message-ID: <CACY--9Fa1bgr0VjwG5E8-4vzBS8zrpOx2ZJsHPsF1rGudmNoyg@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: block premature rproc booting
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Preetham-rao K <preetham.rao@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preetham,

On Mon, Jul 2, 2012 at 1:08 AM, Preetham-rao K
<preetham.rao@stericsson.com> wrote:
>
> Hi Ohad,
>
> Thanks for your reply.
>
> Hi Fernando,
>
> Can you kindly share the patches?


I have some initial patches for that, you can check them on

https://github.com/glfernando/remoteproc/tree/rpmsg_3.4_rc6b_recovery

There are more patches, but they are not ready yet.

Regards,
Fernando.

>
>
> Regards,
> Preetham rao
>
> -----Original Message-----
> From: Ohad Ben-Cohen [mailto:ohad@wizery.com]
> Sent: Friday, June 29, 2012 8:26 PM
> To: Preetham-rao K
> Cc: Fernando Guzman Lugo; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] remoteproc: block premature rproc booting
>
> Hello Preetham rao,
>
> On Fri, Jun 29, 2012 at 2:13 PM, Preetham-rao K
> <preetham.rao@stericsson.com> wrote:
> > We have some questions .
> >
> >
> >
> > Is remoteproc  self governor  the remote processor?
> >
> > When the time of crash on remote processor, will remoteproc take care of
> > loading the firmware?
>
> Yes. the low level driver just has to notify remoteproc that the crash
> occurred, and the remoteproc framework will take care of the rest.
>
> This is not upstream yet - but Fernando (cc'ed) already has the
> patches and can probably share them with you if you're interested.
>
> Ohad.
>
> > Or user has to drive this using remoteproc API?
> >
> >
> >
> > Regards,
> >
> > Preetham rao
