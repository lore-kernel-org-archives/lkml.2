Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942Ab2JWUJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:09:37 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:22222
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933418Ab2JWUJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:09:33 -0400
X-Forefront-Antispam-Report: CIP:157.56.240.117;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0610HT003.namprd06.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI9371Izz1202h1d1ah1d2ahzzz2fh2a8h668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
Message-ID: <5086F963.9070503@convergeddevices.net>
Date: Tue, 23 Oct 2012 13:09:07 -0700
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <hverkuil@xs4all.nl>, <mchehab@redhat.com>, <sameo@linux.intel.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] Add a codec driver for SI476X MFD
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net> <1351017872-32488-7-git-send-email-andrey.smirnov@convergeddevices.net> <20121023192448.GB18814@opensource.wolfsonmicro.com>
In-Reply-To: <20121023192448.GB18814@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.160.178.141]
X-OriginatorOrg: convergeddevices.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 12:24 PM, Mark Brown wrote:
> On Tue, Oct 23, 2012 at 11:44:32AM -0700, Andrey Smirnov wrote:
>> This commit add a sound codec driver for Silicon Laboratories 476x
>> series of AM/FM radio chips.
> I already merged a driver for this.  If there are any changes you should
> send incremental updates rather than a full new driver.

 OK, will do.

