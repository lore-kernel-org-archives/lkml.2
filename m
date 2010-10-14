Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0JNT0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:26:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab0JNT0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:26:42 -0400
Message-ID: <4CB7595C.4000801@redhat.com>
Date: Thu, 14 Oct 2010 21:26:20 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] Fix double free and use generic private pointer
 in per-cpu struct
References: <20101010115941.GA8539@basil.fritz.box>	<4CB1B3B9.4030205@redhat.com>	<20101010130842.GE8256@basil.fritz.box>	<4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com>	<4CB1ECCA.8040801@redhat.com> <20101010170750.GA1475@redhat.com> <4CB20C72.3030504@redhat.com>
In-Reply-To: <4CB20C72.3030504@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2010 08:56 PM, Milan Broz wrote:
> On 10/10/2010 07:07 PM, Mike Snitzer wrote:
> 
>> I'll send patch on top of Andi's v3 if it helps something. (When back to my devel machine).
>> That'll be helpful (I'm sure Andi is interested).
> ok here are my changes on top of v3 - one bugfix and generic IV pointer.
> If you merge it to v4 and it appears in git as one patch I have no problem with that.
> 
> Thanks,
> Milan
> 
> 
> [PATCH] Use generic private pointer in per-cpu struct

Hi Andi,

any progress here?
I would like to achieve some consensus and merge some version
of patch to dm tree...
Maybe with known problems if there is no better solution for now.

Thanks,
Milan
