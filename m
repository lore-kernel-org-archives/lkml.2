Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1F1Rvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:51:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34808 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760585Ab1F1Ruk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:50:40 -0400
MIME-Version: 1.0
In-Reply-To: <6E4D2678AC543844917CA081C9D6B33F04CF4FFC@XMB-AMS-103.cisco.com>
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
	<BANLkTi=gAqpDNBjCXzvNEhSuzm=3Mg9rVg@mail.gmail.com>
	<6E4D2678AC543844917CA081C9D6B33F04CF4FFC@XMB-AMS-103.cisco.com>
Date: Tue, 28 Jun 2011 19:50:38 +0200
Message-ID: <BANLkTim=9ygJScqy12PQXNPBStSgPbpedQ@mail.gmail.com>
Subject: Re: [PATCH v3] Add support for the Philips SA56004 temperature sensor.
From: Fubo Chen <fubo.chen@gmail.com>
To: "Stijn Devriendt (sdevrien)" <sdevrien@cisco.com>
Cc: khali@linux-fr.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, guenter.roeck@ericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 9:04 AM, Stijn Devriendt (sdevrien)
<sdevrien@cisco.com> wrote:
>> On Mon, Jun 6, 2011 at 12:40 PM,  <sdevrien@cisco.com> wrote:
>> > +       } else
>> > +       if (man_id == 0xA1) { /*  NXP Semiconductor/Philips */
>>
>> No kernel coder writes like this. Has this ever been run through
>> checkpatch ?
> It has. Unfortunately this is just the coding style in the whole
> driver. I believe it's better to have a consistent file rather
> than 3 different styles.

Makes sense to me. By the way, it's not forbidden to clean up unusual
coding style from other developers.

Fubo.
