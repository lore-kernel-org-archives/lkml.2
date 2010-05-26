Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab0EZID3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:03:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58956 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0EZID0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:03:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BFCD5BF.1090804@s5r6.in-berlin.de>
Date: Wed, 26 May 2010 10:03:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: post 2.6.34 bug: new code enabled by default
References: <tkrat.872472794cabd92e@s5r6.in-berlin.de> <4BFC9FA5.3040201@redhat.com>
In-Reply-To: <4BFC9FA5.3040201@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> Stefan Richter wrote:
[CONFIG_RC_MAP et al]
>> Please leave the default of new options at N.
>>
>> (Unless this were a special case of new options that replaced older
>> options and need to be migrated to 'on' per default in make oldconfig.
>> I think this is not the case here.)
> 
> This is the case here. Before the RC subsystem, the decoding for NEC and RC-5
> were done inside ir-core (at ir-functions). Also, all the keymap entries (RC_MAP)
> were compiled in-kernel.

OK.  I happened to have a setup in which nothing of this was actually
used before.  (CONFIG_FIREDTV as only DVB tuner driver.)  --- Aha, it is
just a consequence of ir-core being enabled by default regardless if
needed, since 2.6.33:

config IR_CORE
	tristate
	depends on INPUT
	default INPUT
-- 
Stefan Richter
-=====-==-=- -=-= ==-=-
http://arcgraph.de/sr/
