Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0KVLty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 06:49:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42278 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab0KVLtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 06:49:52 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Date: Mon, 22 Nov 2010 17:19:29 +0530
Subject: RE: [PATCH v2 2/4] da850-evm: add UI Expander pushbuttons
Thread-Topic: [PATCH v2 2/4] da850-evm: add UI Expander pushbuttons
Thread-Index: AcuH/8lXJGAfCyexQ7WArG4yAkYvcgCOXsww
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59302477EB2BE@dbde02.ent.ti.com>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
	<95f48a32a0256ecdb7148aa08d16f64928a7e5d8.1289935504.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EA939@dbde02.ent.ti.com>
 <AANLkTi=HS7ym8n6=hF8vAg2WR33Md5=YRZL2NS7a+F2y@mail.gmail.com>
In-Reply-To: <AANLkTi=HS7ym8n6=hF8vAg2WR33Md5=YRZL2NS7a+F2y@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, Nov 19, 2010 at 21:08:10, Ben Gardiner wrote:

> On Fri, Nov 19, 2010 at 4:58 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> > [...]
> > On Wed, Nov 17, 2010 at 01:09:35, Ben Gardiner wrote:
> >> [...]
> >> Changes since v1:
> >>  * set INPUT_POLLDEV default for DA850_EVM machine, but don't select it
> >>    unconditionally
> >
> > I didn't see the v1 posting (wonder why), but why is this
> > required? Why cant we depend on this being selected from
> > Device Drivers->Input device support in menuconfig?
>
> I'm sorry about that. I checked gmane and the v1 never made it to the
> davinci-linux list. I think it was because of my (mis)use of git
> send-email. Version 2 made it to the list so I've now found the magic
> incantation.
>
> The reason we should at least select INPUT_POLLDEV as a default option
> is: when it is not set the gpio-keys instances registered by the
> da850-evm board setup routine will fail probe() of the gpio-keys
> driver since it will not have polled-input support enabled.
>
> By setting INPUT_POLLDEV default for the da850-evm users will get
> functioning pushbuttons and switches with the default config but they
> will be able to disable INPUT_POLLDEV or gpio-keys drivers in their
> defconfig at their convenience.

I guess we could also just modify the defconfig to switch on
INPUT_POLLDEV? Since only gpio-keys functionality is affected
by not enabling the correct options in kernel, it should be OK.

Thanks,
Sekhar

