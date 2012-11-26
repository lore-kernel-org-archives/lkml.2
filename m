Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2KZD4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 22:56:03 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48136 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2KZD4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 22:56:01 -0500
MIME-Version: 1.0
In-Reply-To: <20121126002800.GE31879@valkosipuli.retiisi.org.uk>
References: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
 <CA+V-a8t5ZJ2Zb+dWkifjjOHOrv1LAvgaJR2x24xKJXrTJs9+jg@mail.gmail.com>
 <20121123135753.GB31879@valkosipuli.retiisi.org.uk> <201211231501.52852.hverkuil@xs4all.nl>
 <CA+V-a8sFW7-dkjS=NxM2uJhhOBwTXQ5zGk9hBsA++w6P1PzFMQ@mail.gmail.com> <20121126002800.GE31879@valkosipuli.retiisi.org.uk>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 26 Nov 2012 09:25:40 +0530
Message-ID: <CA+V-a8vpm1Wz9Yxmy0vJZaKw7NCiq1VP4qhFgZApgRk3Lb_XEA@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] Media Controller capture driver for DM365
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Sakari,

On Mon, Nov 26, 2012 at 5:58 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> Hi Prabhakar,
> On Sun, Nov 25, 2012 at 09:57:23PM +0530, Prabhakar Lad wrote:
>> On Fri, Nov 23, 2012 at 7:31 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > On Fri November 23 2012 14:57:53 Sakari Ailus wrote:
> ...
>> >> I think it should go under staging, the same directory as the driver.
>> >>
>> >> Hans, Mauro: could you confirm this?
>> >
>> > I agree with that, that way things stay together in one directory.
>> >
>> Ok I'll have the documentation in staging folder itself. What about
>> the header file which is added
>> to include/media/davinci/xxx.h, these header files are used by machine
>> file and drivers
>> only, I think also moving them to staging wont make sense and also
>> these files are expected
>> not to change, what are your suggestion on this ?
>
> I'd put them to staging if they're related to the driver ifself rather than
> e.g. resource definitions. What would go under arch/arm then?
>
I am targeting only the driver to get into 3.8 and not the machine
changes for DM365.

Regards,
--Prabhakar
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
