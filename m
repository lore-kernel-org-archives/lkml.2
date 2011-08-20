Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab1HTARf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 20:17:35 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:58656
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756622Ab1HTARd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 20:17:33 -0400
X-SpamScore: -6
X-BigFish: VS-6(zz9371K98dKzz1202hzz8275chz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Edgar (gimli) Hucek" <gimli@dark-green.com>,
        Tim Howe <tim.howe@cirrus.com>, Stephen Warren <swarren@nvidia.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH] Sound, Cirrus: Remove redundant check
Thread-Topic: [PATCH] Sound, Cirrus: Remove redundant check
Thread-Index: AQHMXs55aeH7qv4li0u+nvbvT3eHuw==
Date: Sat, 20 Aug 2011 00:16:57 +0000
Message-ID: <CAOZdJXUOLmT1eGZ7wEtk_UacYCPVz_caZwsnOPE_jFNq5svc-g@mail.gmail.com>
References: <alpine.LNX.2.00.1108192358510.31857@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1108192358510.31857@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.129.36.64]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <03857FCAF66FB8489DA0F53167FB72D9@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 6:00 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> The variable 'idxp' is a pointer to 'unsigned int', so the value
> obtained when dereferencing it is always greater than or equal to
> 0. Testing this is redundant.

snd_hda_get_conn_index() can return a negative number, so maybe *idxp
should be a pointer to a signed int?

-- 
Timur Tabi
Linux kernel developer at Freescale
