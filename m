Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2KNAhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:37:22 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:11836 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756056Ab2KNAhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:37:20 -0500
X-Forefront-Antispam-Report: CIP:157.56.234.133;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0610HT003.namprd06.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1de0h1202h1d1ah1d2ahzz17326ah8275dhz2fh2a8h668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
Message-ID: <50A2E7C0.6080501@convergeddevices.net>
Date: Tue, 13 Nov 2012 16:37:20 -0800
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: <broonie@opensource.wolfsonmicro.com>
CC: Andrey Smirnov <andrey.smirnov@convergeddevices.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] regmap: Add no-"bus" configuration possibility
References: <1351988297-16145-1-git-send-email-andrey.smirnov@convergeddevices.net>
In-Reply-To: <1351988297-16145-1-git-send-email-andrey.smirnov@convergeddevices.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.160.178.141]
X-OriginatorOrg: convergeddevices.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2012 05:18 PM, Andrey Smirnov wrote:
> This patch proposes extension to the API that was suggested by Mark in
> the following thread:
> http://article.gmane.org/gmane.linux.kernel/1383734
>
> The idea behind extensions is to allow the devices that expose some
> register-like interface but whose protocol for reading or writing
> those registers could not be simplified to serialized bytestream
> writes to be used within 'regmap' framework
>
> This patch adds two callbacks to the 'regmap' configuration which user
> is expected to set with their implementation of read and write
> functionality for the device.
>
> I am not very well versed with the code of the remap framework so I
> apologize if my proposal has some glaring mistakes and I would
> welcome any suggestion or criticism on how to either improve the code
> or implement the proposal in a better way.
>
> This commit has only purpose of illustrating the proposed extension of
> the 'regmap' API. It has never been compiled or tested.

Mark, did you by any chance had a time to look at this RFC?


