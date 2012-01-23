Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2AWC0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 21:26:17 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:10573
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606Ab2AWC0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 21:26:15 -0500
X-SpamScore: -18
X-BigFish: VS-18(zzbb2dI9371I1432N98dK14ffOzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F1CC533.1050903@freescale.com>
Date: Mon, 23 Jan 2012 00:25:55 -0200
From: Fabio Estevam <fabio.estevam@freescale.com>
Organization: Freescale Semiconductor
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.20) Gecko/20110804 Thunderbird/3.1.12
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
References: <20120123121422.f3e41d97bae580544abfab63@canb.auug.org.au>
In-Reply-To: <20120123121422.f3e41d97bae580544abfab63@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/2012 11:14 PM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> sound/soc/codecs/sgtl5000.c:1398:18: error: 'sgtl500_dapm_widgets' undeclared here (not in a function)
> sound/soc/codecs/sgtl5000.c:1399:22: error: negative width in bit-field '<anonymous>'
> sound/soc/codecs/sgtl5000.c:1400:17: error: 'sgtl500_dapm_routes' undeclared here (not in a function)
> sound/soc/codecs/sgtl5000.c:1401:21: error: negative width in bit-field '<anonymous>'

My apologies. I have just sent the corrected patch to the alsa-devel list.

Regards,

Fabio Estevam


