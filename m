Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2DWRFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:05:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54778 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2DWRE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:04:59 -0400
Message-ID: <4F958BB7.2060007@gmail.com>
Date: Mon, 23 Apr 2012 10:04:55 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: David Daney <ddaney.cavm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 2/2] i2c/of: Automatically populate i2c mux busses
 from device tree data.
References: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com> <1334265263-13549-3-git-send-email-ddaney.cavm@gmail.com> <20120422162008.GA4201@pengutronix.de> <4F9587E8.1050702@gmail.com> <20120423165847.GF27321@pengutronix.de>
In-Reply-To: <20120423165847.GF27321@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 09:58 AM, Wolfram Sang wrote:
>> I can send a new patch set with those corrections, or if you prefer,
>> you could commit these making the changes yourself.
>
> I'll do it, probably faster for both of us :)
>

Great!

Thank you for reviewing this,
David Daney
